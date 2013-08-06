module MessagePack
  module RPC
    REQUEST = 0
    RESPONSE = 1
    NOTIFICATION = 2
    class Client
      def initialize(host, port)
        @socket = TCPSocket.new(host, port)
        @msgid = 0
      end
      def call(method, *args)
        @msgid += 1
        data = [REQUEST, @msgid, method, args].to_msgpack
        @socket.send data, 0
        if @socket.recv(1).getbyte(0) != 0x94
          raise 'invalid response: not 0x94'
        end
        if @socket.recv(1).getbyte(0) != 0x01
          raise 'invalid response: not 0x01'
        end
        if @socket.recv(1).getbyte(0) != @msgid
          raise 'invalid response'
        end
        data = ''
        while true
          data += @socket.recv(1)
          begin
            err = MessagePack.unpack(data)
          rescue
            next
          end
          break if err == nil
          raise err
        end
        data = ''
        while true
          data += @socket.recv(1)
          begin
            return MessagePack.unpack(data)
          rescue
          end
        end
      end
    end
  end
end
