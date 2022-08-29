require "./server"

module Cbloom
  class Executor
    def initialize(**opts)
      @directory = opts["directory"].as(String)
      @slice = opts["slice"].as(Int32)
      @probability = opts["probability"].as(Float32)
      @item = opts["item"].as(Int64)
      @flush = opts["flush"].as(Int32)
      @port = opts["port"].as(Int32)

      validate!
    end

    def call
      if File.exists?(File.join(@directory, "config.json"))
        cluster = load_cluster
        start_server(cluster, @port)
      else
        cluster = setup_cluster
        start_server(cluster, @port)
      end
    end

    private def setup_cluster
      cluster = Cluster.create(
        directory: @directory,
        slice: @slice,
        probability: @probability,
        item: @item,
        port: @port
      )
      cluster.build.flush
      cluster
    end

    private def load_cluster
      Cluster.load(@directory)
    end

    private def start_server(cluster, port)
      BloomServer.new(cluster, port).start
    end

    private def validate!
      if (@item // @slice) > 400_000_000
        raise Exception.new("Probably slice number should be #{@item // 400_000_000}")
      end
    end
  end
end
