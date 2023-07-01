from fractions import Fraction
import itertools
try: zip = itertools.izip
except: pass

# The Continued Fraction
def CF(a, b, t):
  terms = list(itertools.islice(zip(a, b), t))
  z = Fraction(1,1)
  for a, b in reversed(terms):
    z = a + b / z
  return z

# Approximates a fraction to a string
def pRes(x, d):
  q, x = divmod(x, 1)
  res = str(q)
  res += "."
  for i in range(d):
    x *= 10
    q, x = divmod(x, 1)
    res += str(q)
  return res

# Test the Continued Fraction for sqrt2
def sqrt2_a():
  yield 1
  for x in itertools.repeat(2):
    yield x

def sqrt2_b():
  for x in itertools.repeat(1):
    yield x

cf = CF(sqrt2_a(), sqrt2_b(), 950)
print(pRes(cf, 200))
#1.41421356237309504880168872420969807856967187537694807317667973799073247846210703885038753432764157273501384623091229702492483605585073721264412149709993583141322266592750559275579995050115278206057147


# Test the Continued Fraction for Napier's Constant
def Napier_a():
  yield 2
  for x in itertools.count(1):
    yield x

def Napier_b():
  yield 1
  for x in itertools.count(1):
    yield x

cf = CF(Napier_a(), Napier_b(), 950)
print(pRes(cf, 200))
#2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742746639193200305992181741359662904357290033429526059563073813232862794349076323382988075319525101901

# Test the Continued Fraction for Pi
def Pi_a():
  yield 3
  for x in itertools.repeat(6):
    yield x

def Pi_b():
  for x in itertools.count(1,2):
    yield x*x

cf = CF(Pi_a(), Pi_b(), 950)
print(pRes(cf, 10))
#3.1415926532
