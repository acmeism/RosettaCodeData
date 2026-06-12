#!/bin/env python3

#---------------------------------------------------------------------

class ContinuedFraction:

    def __init__ (self, func, env = None):
        self._terminated = False # Are there no more terms?
        self._memo = []          # The memoized terms.
        self._func = func        # A function that produces terms.
        self._env = env          # An environment for _func.

    def __getitem__ (self, i):
        while not self._terminated and len(self._memo) <= i:
            term = self._func (i, self._env) # i may be ignored.
            if term is None:
                self._terminated = True
            else:
                self._memo.append (term)
        return (self._memo[i] if i < len(self._memo) else None)

class NG8:

    def __init__ (self, a12, a1, a2, a, b12, b1, b2, b):
        self.a12 = a12
        self.a1 = a1
        self.a2 = a2
        self.a = a
        self.b12 = b12
        self.b1 = b1
        self.b2 = b2
        self.b = b

    def coefs (self):
        return (self.a12, self.a1, self.a2, self.a,
                self.b12, self.b1, self.b2, self.b)

    def __call__ (self, x, y):
        return apply_ng8 (self.coefs(), x, y)

#---------------------------------------------------------------------

def cf2string (cf, max_terms = 20):
    i = 0
    s = "["
    done = False
    while not done:
        term = cf[i]
        if term is None:
            s += "]"
            done = True
        elif i == max_terms:
            s += ",...]"
            done = True
        else:
            if i == 0:
                separator = ""
            elif i == 1:
                separator = ";"
            else:
                separator = ","
            s += separator
            s += str (term)
            i += 1
    return s

def r2cf (n, d):                # Rational to continued fraction.
    def func (i, env):
        n = env[0]
        d = env[1]
        if d == 0 :
            retval = None
        else:
            q = n // d
            r = n - (q * d)
            env[0] = d
            env[1] = r
            retval = q
        return retval
    return ContinuedFraction (func, [n, d])

def i2cf (i):                   # Integer to continued fraction.
    return r2cf (i, 1)

def apply_ng8 (ng8_tuple, x, y):

    # Thresholds chosen merely for demonstration.
    number_that_is_too_big = 2 ** 512
    practically_infinite = 2 ** 64

    ng = 0
    ix = 1
    iy = 2
    xoverflow = 3
    yoverflow = 4

    def too_big (values):
        # Stop computing if a number reaches the threshold.
        return any ((abs (x) >= abs (number_that_is_too_big)
                     for x in values))

    def treat_as_infinite (x):
        return (abs (x) >= abs (practically_infinite))

    def func (i, env):

        def absorb_x_term ():
            (a12, a1, a2, a, b12, b1, b2, b) = env[ng]
            if env[xoverflow]:
                term = None
            else:
                term = x[env[ix]]
            env[ix] += 1
            if term is not None:
                new_ng = (a2 + (a12 * term), a + (a1 * term), a12, a1,
                          b2 + (b12 * term), b + (b1 * term), b12, b1)
                if not too_big (new_ng):
                    env[ng] = new_ng
                else:
                    env[ng] = (a12, a1, a12, a1, b12, b1, b12, b1)
                    env[xoverflow] = True
            else:
                env[ng] = (a12, a1, a12, a1, b12, b1, b12, b1)
            return

        def absorb_y_term ():
            (a12, a1, a2, a, b12, b1, b2, b) = env[ng]
            if env[yoverflow]:
                term = None
            else:
                term = y[env[iy]]
            env[iy] += 1
            if term is not None:
                new_ng = (a1 + (a12 * term), a12, a + (a2 * term), a2,
                          b1 + (b12 * term), b12, b + (b2 * term), b2)
                if not too_big (new_ng):
                    env[ng] = new_ng
                else:
                    env[ng] = (a12, a12, a2, a2, b12, b12, b2, b2)
                    env[yoverflow] = True
            else:
                env[ng] = (a12, a12, a2, a2, b12, b12, b2, b2)
            return

        done = False
        while not done:
            (a12, a1, a2, a, b12, b1, b2, b) = env[ng]
            if b == 0 and b1 == 0 and b2 == 0 and b12 == 0:
                # There are no more terms.
                retval = None
                done = True
            elif b == 0 and b2 == 0:
                absorb_x_term ()
            elif b == 0 or b2 == 0:
                absorb_y_term ()
            elif b1 == 0:
                absorb_x_term ()
            else:
                q = a // b
                q1 = a1 // b1
                q2 = a2 // b2
                if b12 != 0:
                    q12 = a12 // b12
                if b12 != 0 and q == q1 and q == q2 and q == q12:
                    # Output a term. Notice the resemblance to r2cf.
                    env[0] = (b12, b1, b2, b,  # Divisors.
                              a12 - (b12 * q), # Remainder.
                              a1 - (b1 * q),   # Remainder.
                              a2 - (b2 * q),   # Remainder.
                              a - (b * q))     # Remainder.
                    retval = (None if treat_as_infinite (q) else q)
                    done = True
                else:
                    # Rather than compare fractions, we will put the
                    # numerators over a common denominator of b*b1*b2,
                    # and then compare the new numerators.
                    n = a * b1 * b2
                    n1 = a1 * b * b2
                    n2 = a2 * b * b1
                    if abs (n1 - n) > abs (n2 - n):
                        absorb_x_term ()
                    else:
                        absorb_y_term ()
        return retval

    return ContinuedFraction (func, [ng8_tuple, 0, 0, False, False])

#---------------------------------------------------------------------

golden_ratio = ContinuedFraction (lambda i, env : 1) # (1 + sqrt(5))/2
silver_ratio = ContinuedFraction (lambda i, env : 2) # 1 + sqrt(2)
sqrt2 = ContinuedFraction (lambda i, env : 1 if i == 0 else 2)
frac_13_11 = r2cf (13, 11)
frac_22_7 = r2cf (22, 7)
one = i2cf (1)
two = i2cf (2)
three = i2cf (3)
four = i2cf (4)

cf_add = NG8 (0, 1, 1, 0, 0, 0, 0, 1)
cf_sub = NG8 (0, 1, -1, 0, 0, 0, 0, 1)
cf_mul = NG8 (1, 0, 0, 0, 0, 0, 0, 1)
cf_div = NG8 (0, 1, 0, 0, 0, 0, 1, 0)

print ("      golden ratio => ", cf2string (golden_ratio))
print ("      silver ratio => ", cf2string (silver_ratio))
print ("           sqrt(2) => ", cf2string (sqrt2))
print ("             13/11 => ", cf2string (frac_13_11))
print ("              22/7 => ", cf2string (frac_22_7))
print ("                 1 => ", cf2string (one))
print ("                 2 => ", cf2string (two))
print ("                 3 => ", cf2string (three))
print ("                 4 => ", cf2string (four))
print (" (1 + 1/sqrt(2))/2 => ",
       cf2string (cf_div (cf_add (one, cf_div (one, sqrt2)), two)),
       "  method 1")
print (" (1 + 1/sqrt(2))/2 => ",
       cf2string (NG8 (1, 0, 0, 1, 0, 0, 0, 8) (silver_ratio,
                                                silver_ratio)),
       "  method 2")
print (" (1 + 1/sqrt(2))/2 => ",
       cf2string (cf_div (cf_div (cf_div (silver_ratio, sqrt2),
                                  sqrt2),
                          sqrt2)),
       "  method 3")
print (" sqrt(2) + sqrt(2) => ", cf2string (cf_add (sqrt2, sqrt2)))
print (" sqrt(2) - sqrt(2) => ", cf2string (cf_sub (sqrt2, sqrt2)))
print (" sqrt(2) * sqrt(2) => ", cf2string (cf_mul (sqrt2, sqrt2)))
print (" sqrt(2) / sqrt(2) => ", cf2string (cf_div (sqrt2, sqrt2)))

#---------------------------------------------------------------------
