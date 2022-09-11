require "nanoid"
require "json"
require "./bloom"

module Cbloom
  class Cluster
    property filters

    def self.create(**opts)
      new(**opts)
    end

    def self.load(directory)
      string = File.read(File.join(directory, "config.json"))
      opts = Hash(String, String | Float32 | Int32 | Int64).from_json(string)

      cluster = create(
        directory: opts["directory"].to_s,
        shards: opts["shards"].to_i32,
        probability: opts["probability"].to_f32,
        item: opts["item"].to_i64
      )

      bitmaps = Dir.glob(File.join(opts["directory"].as(String), "*.bitmap")).map do |f|
        File.basename(f)
      end.sort

      item = (opts["item"].as(Int64) // bitmaps.size).to_i32

      filters = bitmaps.map do |name|
        Bloom.load(name, item, opts["probability"].as(Float32), opts["directory"].as(String))
      end

      cluster.filters = filters
      puts "Previous configuration from #{directory} loaded"
      cluster
    end

    def initialize(**opts)
      @item = opts["item"].as(Int64)
      @shards = opts["shards"].as(Int32)
      @probability = opts["probability"].as(Float32)
      @directory = opts["directory"].as(String)
      @filters = Array(Bloom).new
    end

    def build
      Dir.mkdir_p(@directory) unless Dir.exists?(@directory)
      @shards.times do |idx|
        name = idx > 9 ? "" : "0"
        filter_name = "#{name}#{idx}.bitmap"
        items_number = (@item // @shards).to_i32
        @filters.push Bloom.create(filter_name, items_number, @probability, @directory)
      end
      puts "New configuration builded"
      self
    end

    def get
      hash = Nanoid.generate(size: rand(1..6))
      with_partition(hash) do |filter|
        if filter.has?(hash)
          get
        else
          filter.add(hash)
          hash
        end
      end
    end

    def flush
      @filters.each(&.flush)
      File.open(File.join(@directory, "config.json"), "w") do |io|
        io << {
          item:        @item,
          shards:      @shards,
          probability: @probability,
          directory:   @directory,
        }.to_json
      end
      true
    end

    private def with_partition(hash)
      hash_int = to_int(hash)
      partition_num = hash_int % @shards
      yield @filters[partition_num]
    end

    private def to_int(hash)
      hash.codepoints.join.to_i64
    end
  end
end
