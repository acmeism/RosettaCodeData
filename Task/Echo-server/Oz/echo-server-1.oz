declare
  ServerSocket = {New Open.socket init}

  proc {Echo Socket}
     case {Socket getS($)} of false then skip
     [] Line then
        {System.showInfo "Received line: "#Line}
        {Socket write(vs:Line#"\n")}
        {Echo Socket}
     end
  end

  class TextSocket from Open.socket Open.text end
in
  {ServerSocket bind(takePort:12321)}
  {System.showInfo "Socket bound."}

  {ServerSocket listen}
  {System.showInfo "Started listening."}

  for do
     ClientHost ClientPort
     ClientSocket = {ServerSocket accept(accepted:$
					 acceptClass:TextSocket
					 host:?ClientHost
					 port:?ClientPort
					)}
  in
     {System.showInfo "Connection accepted from "#ClientHost#":"#ClientPort#"."}
     thread
        {Echo ClientSocket}

	{System.showInfo "Connection lost: "#ClientHost#":"#ClientPort#"."}
        {ClientSocket close}
     end
  end
