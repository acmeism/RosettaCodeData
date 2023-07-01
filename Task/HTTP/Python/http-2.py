from http.client import HTTPConnection
conn = HTTPConnection("example.com")
# If you need to use set_tunnel, do so here.
conn.request("GET", "/")
# Alternatively, you can use connect(), followed by the putrequest, putheader and endheaders functions.
result = conn.getresponse()
r1 = result.read() # This retrieves the entire contents.
