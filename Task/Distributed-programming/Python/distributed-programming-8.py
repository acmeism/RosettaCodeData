#!/usr/bin/python
# -*- coding: utf-8 -*-

import Pyro.core

DATA = "my name is eren"
NUM1 = 10
NUM2 = 5

string = Pyro.core.getProxyForURI("PYRONAME://string")
math = Pyro.core.getProxyForURI("PYRONAME://math")

print 'We sent: %s' % DATA
print 'Server responded: %s\n' % string.makeUpper(DATA)

print 'We sent two numbers to divide: %d and %d' % (NUM1, NUM2)
print 'Server responded the result: %s' % math.div(NUM1, NUM2)
