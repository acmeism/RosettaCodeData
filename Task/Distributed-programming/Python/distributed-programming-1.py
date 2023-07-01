#!/usr/bin/env python
# -*- coding: utf-8 -*-

import SimpleXMLRPCServer

class MyHandlerInstance:
    def echo(self, data):
        '''Method for returning data got from client'''
        return 'Server responded: %s' % data

    def div(self, num1, num2):
        '''Method for divide 2 numbers'''
        return num1/num2

def foo_function():
    '''A function (not an instance method)'''
    return True

HOST = "localhost"
PORT = 8000

server = SimpleXMLRPCServer.SimpleXMLRPCServer((HOST, PORT))

# register built-in system.* functions.
server.register_introspection_functions()

# register our instance
server.register_instance(MyHandlerInstance())

# register our function as well
server.register_function(foo_function)

try:
    # serve forever
    server.serve_forever()
except KeyboardInterrupt:
    print 'Exiting...'
    server.server_close()
