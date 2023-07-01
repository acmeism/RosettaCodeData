#!/usr/bin/python
# -*- coding: utf-8 -*-

import SocketServer
import pickle

HOST = "localhost"
PORT = 8000

class RPCServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    # The object_to_proxy member should be set to the object we want
    # methods called on. Unfortunately, we can't do this in the constructor
    # because the constructor should not be overridden in TCPServer...

    daemon_threads = True

class RPCHandler(SocketServer.StreamRequestHandler):
    def handle(self):
        in_channel = pickle.Unpickler(self.rfile)
        out_channel = pickle.Pickler(self.wfile, protocol=2)
        while True:
            try:
                name, args, kwargs = in_channel.load()
                print 'got %s %s %s' % (name, args, kwargs)
            except EOFError:
                # EOF means we're done with this request.
                # Catching this exception to detect EOF is a bit hackish,
                # but will work for a quick demo like this
                break
            try:
                method = getattr(self.server.object_to_proxy, name)
                result = method(*args, **kwargs)
            except Exception, e:
                out_channel.dump(('Error',e))
            else:
                out_channel.dump(('OK',result))

class MyHandlerInstance(object):
    def echo(self, data):
        '''Method for returning data got from client'''
        return 'Server responded: %s' % data

    def div(self, dividend, divisor):
        '''Method to divide 2 numbers'''
        return dividend/divisor

    def is_computer_on(self):
        return True

if __name__ == '__main__':
    rpcserver = RPCServer((HOST, PORT), RPCHandler)
    rpcserver.object_to_proxy = MyHandlerInstance()
    try:
        rpcserver.serve_forever()
    except KeyboardInterrupt:
        print 'Exiting...'
        rpcserver.server_close()
