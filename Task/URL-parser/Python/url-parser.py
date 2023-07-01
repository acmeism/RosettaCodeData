import urllib.parse as up # urlparse for Python v2

url = up.urlparse('http://user:pass@example.com:8081/path/file.html;params?query1=1#fragment')

print('url.scheme = ', url.scheme)
print('url.netloc = ', url.netloc)
print('url.hostname = ', url.hostname)
print('url.port = ', url.port)
print('url.path = ', url.path)
print('url.params = ', url.params)
print('url.query = ', url.query)
print('url.fragment = ', url.fragment)
print('url.username = ', url.username)
print('url.password = ', url.password)
