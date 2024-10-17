defmodule Sockets do
  require Logger

  def send_message(port, message) do
    {:ok, socket} = :gen_tcp.connect('localhost', port, [])
    :gen_tcp.send(socket, message)
  end
end

Sockets.send_message(256, "hello socket world")
