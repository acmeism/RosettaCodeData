#!/usr/bin/python
# -*- coding: utf-8 -*-

import Pyro.core
import Pyro.naming

# create instance that will return upper case
class StringInstance(Pyro.core.ObjBase):
    def makeUpper(self, data):
        return data.upper()

class MathInstance(Pyro.core.ObjBase):
    def div(self, num1, num2):
        return num1/num2

if __name__ == '__main__':
    server = Pyro.core.Daemon()
    name_server = Pyro.naming.NameServerLocator().getNS()
    server.useNameServer(name_server)
    server.connect(StringInstance(), 'string')
    server.connect(MathInstance(), 'math')
    try:
        server.requestLoop()
    except KeyboardInterrupt:
        print 'Exiting...'
        server.shutdown()
