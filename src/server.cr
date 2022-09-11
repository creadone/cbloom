require "socket"

module Cbloom
  class BloomServer
    def initialize(@cluster : Cluster)
      @socket_path = "/var/run/cbloom.sock"
      @server = UNIXServer.new(@socket_path)

      Signal::INT.trap do
        spawn do
          @server.close
          @cluster.flush
          puts "Cbloom Stopped"
        end
        sleep 0.1
        exit(0)
      end
    end

    def handle(client)
      while message = client.gets
        case message
        when "get"
          client.send "#{@cluster.get}\r\n"
          client.flush
        when "flush"
          client.puts @cluster.flush
        end
      end
    end

    def start
      puts "Cbloom v#{Cbloom::VERSION} started on #{@socket_path}"
      while client = @server.accept?
        spawn handle(client)
      end
    end

  end
end
