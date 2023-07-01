declare
  Socket = {New class $ from Open.socket Open.text end init}
in
  {Socket connect(port:12321)}
  {Socket write(vs:"Hello\n")}
  {System.showInfo "Client received: "#{Socket getS($)}}
  {Socket close}
