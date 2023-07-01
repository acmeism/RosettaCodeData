#!/usr/bin/python
# -*- coding: utf-8 -*-

import socket
import pickle

HOST = "localhost"
PORT = 8000

class RPCClient(object):
    def __init__(self, host, port):
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((host, port))
        self.rfile = self.socket.makefile('rb')
        self.wfile = self.socket.makefile('wb')
        self.in_channel = pickle.Unpickler(self.rfile)
        self.out_channel = pickle.Pickler(self.wfile, protocol=2)

    def _close(self):
        self.socket.close()
        self.rfile.close()
        self.wfile.close()

    # Make calling remote methods easy by overriding attribute access.
    # Accessing any attribute on our instances will give a proxy method that
    # calls the method with the same name on the remote machine.
    def __getattr__(self, name):
        def proxy(*args, **kwargs):
            self.out_channel.dump((name, args, kwargs))
            self.wfile.flush() # to make sure the server won't wait forever
            status, result = self.in_channel.load()
            if status == 'OK':
                return result
            else:
                raise result

        return proxy

if __name__ == '__main__':
    # connect to server and send data
    rpcclient = RPCClient(HOST, PORT)

    print 'Testing the echo() method:'
    print rpcclient.echo('Hello world!')
    print
    print 'Calculating 42/2 on the remote machine:'
    print rpcclient.div(42, 2)
    print
    print 'is_computer_on on the remote machine returns:'
    print rpcclient.is_computer_on()
    print
    print 'Testing keyword args:'
    print '42/2 is:', rpcclient.div(divisor=2, dividend=42)
    rpcclient._close()
    del rpcclient
