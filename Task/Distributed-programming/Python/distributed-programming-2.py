#!/usr/bin/env python
# -*- coding: utf-8 -*-

import xmlrpclib

HOST = "localhost"
PORT = 8000

rpc = xmlrpclib.ServerProxy("http://%s:%d" % (HOST, PORT))

# print what functions does server support
print 'Server supports these functions:',
print ' '.join(rpc.system.listMethods())

# echo something
rpc.echo("We sent this data to server")

# div numbers
print 'Server says: 8 / 4 is: %d' % rpc.div(8, 4)

# control if foo_function returns True
if rpc.foo_function():
    print 'Server says: foo_function returned True'
