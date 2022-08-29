require "option_parser"
require "./cluster"
require "./executor"

module Cbloom
  VERSION = `shards version`.strip

  directory = "./bitmaps"
  slice = 5
  probability = 0.01_f32
  item = 1_000_000_i64
  flush = 20
  port = 2022_i32

  OptionParser.parse do |parser|
    parser.banner = "Usage: cbloom [arguments]"

    parser.on("-d PATH", "--directory=PATH", "Path to directory where bitmaps are stored") do |path|
      directory = Path[path.strip].expand.to_s
    end

    parser.on("-s INT", "--slice=INT", "Number of bloom filter slices") do |int|
      slice = int.to_i32
    end

    parser.on("-e FLOAT", "--probability=FLOAT", "Probability of false positives") do |float|
      probability = float.to_f32
    end

    parser.on("-i INT", "--item=INT", "Max number of items") do |int|
      item = int.to_i64
    end

    parser.on("-p INT", "--port=INT", "Port for HTTP Server") do |int|
      port = int.to_i32
    end

    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end

    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option.\n"
      STDERR.puts parser
      exit(1)
    end
  end

  Executor.new(
    directory: directory,
    slice: slice,
    probability: probability,
    item: item,
    flush: flush,
    port: port
  ).call
end