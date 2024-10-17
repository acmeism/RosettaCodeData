##
var ip := System.Net.Dns.GetHostEntry('www.kame.net');
foreach var address in ip.AddressList do
  println(address);
