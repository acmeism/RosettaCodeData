import httpclient

for mac in ["FC-A1-3E", "FC:FB:FB:01:FA:21", "BC:5F:F4"]:
  echo newHttpClient().getContent("http://api.macvendors.com/"&mac)
