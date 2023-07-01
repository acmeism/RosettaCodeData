import time

def chunks(l, n=5):
    return [l[i:i+n] for i in range(0, len(l), n)]

def binary(n, digits=8):
    n=int(n)
    return '{0:0{1}b}'.format(n, digits)

def secs(n):
    n=int(n)
    h='x' * n
    return "|".join(chunks(h))

def bin_bit(h):
    h=h.replace("1","x")
    h=h.replace("0"," ")
    return "|".join(list(h))


x=str(time.ctime()).split()
y=x[3].split(":")

s=y[-1]
y=map(binary,y[:-1])

print bin_bit(y[0])
print
print bin_bit(y[1])
print
print secs(s)
