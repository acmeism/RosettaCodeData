#!/usr/local/bin/python3
import os,sys
def bit2lam(bit) :
  return lambda x0: lambda x1: x1 if bit else x0
def byte2lam(bits,n) :
  if (n==0) :
    return lambda _:lambda y: y
  return lambda z: z (bit2lam((bits>>(n-1))&1)) (byte2lam(bits,n-1))
def input(n) :           # input from n'th character onward
  if n >= len(inp) :
    c = os.read(0,1)
    inp.append((lambda _: lambda y: y) if c==b''
          else lambda z: z(byte2lam(c[0],8) if bytemode else bit2lam(c[0]&1))(input(n+1)))
  return inp[n]
def lam2bit(lambit) :
  return lambit(lambda _: 0)(lambda _: 1)(0)  # force suspension
def lam2byte(lambits, x) :
  return lambits(lambda lambit: lambda lamtail: lambda _: lam2byte(lamtail, 2*x+lam2bit(lambit)))(bytes([x]))
def output(prog) :
  return prog(lambda c: os.write(1,lam2byte(c,0) if bytemode else (b'1' if lam2bit(c) else b'0')) and (lambda tail: lambda _ : output(tail)))(0)
def getbit() :
  global nbit, progchar
  if nbit==0 :
    progchar = os.read(0,1)[0]
    nbit = 8 if bytemode else 1
  nbit -= 1
  return (progchar >> nbit) & 1
def program() :
  if getbit() :                # variable
    i = 0
    while (getbit()==1) : i += 1
    return lambda *args : args[i]
  elif getbit() :         # application
    p = program()
    q = program()
    return lambda *args : p(*args)(lambda arg: q(*args)(arg)) # suspend argument
  else :
    p = program()
    return lambda *args: lambda arg: p(arg, *args) # extend environment with one more argument
sys.setrecursionlimit(8192)
inp = []
nbit = progchar = 0
bytemode = len(sys.argv) <= 1
prog = program()(0)
output(prog(input(0)))             # run program with empty env on input
