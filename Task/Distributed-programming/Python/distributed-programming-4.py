#!/usr/bin/python
# -*- coding: utf-8 -*-

import httplib

HOST = "localhost"
PORT = 8000

conn = httplib.HTTPConnection(HOST, PORT)
conn.request("GET", "/somefile")

response = conn.getresponse()
print 'Server Status: %d' % response.status

print 'Server Message: %s' % response.read()
