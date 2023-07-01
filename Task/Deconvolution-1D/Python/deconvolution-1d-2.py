import numpy

h = [-8,-9,-3,-1,-6,7]
f = [-3,-6,-1,8,-6,3,-1,-9,-9,3,-2,5,2,-2,-7,-1]
g = [24,75,71,-34,3,22,-45,23,245,25,52,25,-67,-96,96,31,55,36,29,-43,-7]

# https://stackoverflow.com/questions/14267555/find-the-smallest-power-of-2-greater-than-n-in-python

def shift_bit_length(x):
    return 1<<(x-1).bit_length()

def conv(a, b):
    p = len(a)
    q = len(b)
    n = p + q - 1
    r = shift_bit_length(n)
    y = numpy.fft.ifft(numpy.fft.fft(a,r) * numpy.fft.fft(b,r),r)
    return numpy.trim_zeros(numpy.around(numpy.real(y),decimals=6))

def deconv(a, b):
    p = len(a)
    q = len(b)
    n = p - q + 1
    r = shift_bit_length(max(p, q))
    y = numpy.fft.ifft(numpy.fft.fft(a,r) / numpy.fft.fft(b,r), r)
    return numpy.trim_zeros(numpy.around(numpy.real(y),decimals=6))

# should return g

print(conv(h,f))

# should return h

print(deconv(g,f))

# should return f

print(deconv(g,h))
