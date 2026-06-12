import urllib
import base64

data = urllib.urlopen('http://rosettacode.org/favicon.ico').read()
print base64.b64encode(data)
