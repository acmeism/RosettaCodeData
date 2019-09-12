"""

https://rosettacode.org/wiki/Deconvolution/2D%2B

Working on 3 dimensional example using test data from the
RC task.

Python fft:

https://docs.scipy.org/doc/numpy/reference/routines.fft.html

"""

import numpy
import pprint

h =  [
      [[-6, -8, -5, 9], [-7, 9, -6, -8], [2, -7, 9, 8]],
      [[7, 4, 4, -6], [9, 9, 4, -4], [-3, 7, -2, -3]]]
f =  [
      [[-9, 5, -8], [3, 5, 1]],
      [[-1, -7, 2], [-5, -6, 6]],
      [[8, 5, 8],[-2, -6, -4]]]
g =  [
      [
         [54, 42, 53, -42, 85, -72],
         [45, -170, 94, -36, 48, 73],
         [-39, 65, -112, -16, -78, -72],
         [6, -11, -6, 62, 49, 8]],
      [
         [-57, 49, -23, 52, -135, 66],
         [-23, 127, -58, -5, -118, 64],
         [87, -16, 121, 23, -41, -12],
         [-19, 29, 35, -148, -11, 45]],
      [
         [-55, -147, -146, -31, 55, 60],
         [-88, -45, -28, 46, -26, -144],
         [-12, -107, -34, 150, 249, 66],
         [11, -15, -34, 27, -78, -50]],
      [
         [56, 67, 108, 4, 2, -48],
         [58, 67, 89, 32, 32, -8],
         [-42, -31, -103, -30, -23, -8],
         [6, 4, -26, -10, 26, 12]]]

def trim_zero_empty(x):
    """

    Takes a structure that represents an n dimensional example.
    For a 2 dimensional example it will be a list of lists.
    For a 3 dimensional one it will be a list of list of lists.
    etc.

    Actually these are multidimensional numpy arrays but I was thinking
    in terms of lists.

    Returns the same structure without trailing zeros in the inner
    lists and leaves out inner lists with all zeros.

    """

    if len(x) > 0:
        if type(x[0]) != numpy.ndarray:
            # x is 1d array
            return list(numpy.trim_zeros(x))
        else:
            # x is a multidimentional array
            new_x = []
            for l in x:
               tl = trim_zero_empty(l)
               if len(tl) > 0:
                   new_x.append(tl)
            return new_x
    else:
        # x is empty list
        return x

def deconv(a, b):
    """

    Returns function c such that b * c = a.

    https://en.wikipedia.org/wiki/Deconvolution

    """

    # Convert larger polynomial using fft

    ffta = numpy.fft.fftn(a)

    # Get it's shape so fftn will expand
    # smaller polynomial to fit.

    ashape = numpy.shape(a)

    # Convert smaller polynomial with fft
    # using the shape of the larger one

    fftb = numpy.fft.fftn(b,ashape)

    # Divide the two in frequency domain

    fftquotient = ffta / fftb

    # Convert back to polynomial coefficients using ifft
    # Should give c but with some small extra components

    c = numpy.fft.ifftn(fftquotient)

    # Get rid of imaginary part and round up to 6 decimals
    # to get rid of small real components

    trimmedc = numpy.around(numpy.real(c),decimals=6)

    # Trim zeros and eliminate
    # empty rows of coefficients

    cleanc = trim_zero_empty(trimmedc)

    return cleanc

print("deconv(g,h)=")

pprint.pprint(deconv(g,h))

print(" ")

print("deconv(g,f)=")

pprint.pprint(deconv(g,f))
