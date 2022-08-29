require "bloom_filter"

module Cbloom
  class Bloom
    def self.load(name : String, item : Int32, probability : Float32, directory : String)
      path = File.join(directory, name)
      filter = BloomFilter.load_file(path)
      new(name, item, probability, directory, filter)
    end

    def self.create(name : String, item : Int32, probability : Float32, directory : String)
      filter = BloomFilter.new_optimal(item, probability)
      new(name, item, probability, directory, filter)
    end

    # Generation from scratch
    def initialize(@name : String, @item : Int32, @probability : Float32, @directory : String, @filter : BloomFilter::Filter)
      @path = File.join(@directory, @name)
    end

    def has?(hash : String)
      @filter.has?(hash)
    end

    def add(hash : String)
      @filter.insert(hash)
    end

    def flush
      @filter.dump_file(@path)
    end
  end
end
