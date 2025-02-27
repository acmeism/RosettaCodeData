##
uses System.Net;

ServicePointManager.SecurityProtocol := SecurityProtocolType(3072);
var wc := new WebClient;

foreach var mac in |'FC-A1-3E', 'FC:FB:FB:01:FA:21', 'BC:5F:F4'| do
begin
  println(mac, wc.DownloadString('https://api.macvendors.com/' + mac));
  Sleep(1500);
end;
