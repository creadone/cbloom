require "./server"

module Cbloom
  class Executor
    def initialize(**opts)
      @directory = opts["directory"].as(String)
      @shards = opts["shards"].as(Int32)
      @probability = opts["probability"].as(Float32)
      @item = opts["item"].as(Int64)

      validate!
    end

    def call
      if File.exists?(File.join(@directory, "config.json"))
        cluster = load_cluster
        start_server(cluster)
      else
        cluster = setup_cluster
        start_server(cluster)
      end
    end

    private def setup_cluster
      cluster = Cluster.create(
        directory: @directory,
        shards: @shards,
        probability: @probability,
        item: @item
      )
      cluster.build.flush
      cluster
    end

    private def load_cluster
      Cluster.load(@directory)
    end

    private def start_server(cluster)
      BloomServer.new(cluster).start
    end

    private def validate!
      if (@item // @shards) > 400_000_000
        raise Exception.new("Probably shard number should be #{@item // 400_000_000}")
      end
    end
  end
end
