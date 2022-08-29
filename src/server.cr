require "http/server"

module Cbloom
  class BloomServer
    def initialize(@cluster : Cluster, @port : Int32)
    end

    def start
      server = HTTP::Server.new do |context|
        context.response.content_type = "text/plain"
        if context.request.resource == "/get"
          context.response.puts @cluster.get
        elsif context.request.resource == "/flush"
          context.response.puts @cluster.flush
        else
          context.response.puts "Cbloom v#{Cbloom::VERSION}"
        end
      end

      address = server.bind_tcp "0.0.0.0", @port
      puts "Cbloom v#{Cbloom::VERSION} listening on http://#{address}"
      server.listen
    end
  end
end
