import math

class PAdicSqrtNumber:

    DIGITS_SIZE = 25   # Maximum number of p-adic digits to store
    MAX_ORDER = 1000   # Sentinel value for representing zero
    PRECISION = 20     # Precision for rational reconstruction

    def __init__(self, prime: int, numerator: int, denominator: int):
        if denominator == 0:
            raise ZeroDivisionError("Denominator cannot be zero")

        # Store original rational for debugging / reconstruction
        self._originalNumerator = int(numerator)
        self._originalDenominator = int(denominator)

        self.prime = prime
        self.digits = []  # Stores digits of the p-adic expansion
        self.order = 0    # Exponent of prime factored out (valuation)

        # Case: numerator is zero → the entire number is zero
        if numerator == 0:
            self.order = self.MAX_ORDER
            return

        numerator = int(numerator)
        denominator = int(denominator)

        # Factor out powers of prime from numerator
        while numerator % self.prime == 0:
            numerator //= self.prime
            self.order += 1
        # Factor out powers of prime from denominator
        while denominator % self.prime == 0:
            denominator //= self.prime
            self.order -= 1

        # Ensure the valuation is even (so the square root exists)
        if self.order & 1 != 0:
            raise AssertionError(f"Number does not have a square root in {self.prime}-adic")
        self.order >>= 1

        # Use specialized algorithms depending on whether prime = 2 or odd
        if self.prime == 2:
            self._squareRootEvenPrime(numerator, denominator)
        else:
            self._squareRootOddPrime(numerator, denominator)

        self._padWithZeros(self.digits)

    @classmethod
    def fromDigits(cls, prime: int, digits: list[int], order: int) -> "PAdicSqrtNumber":
        """Construct directly from digits and order (used internally)."""
        obj = cls.__new__(cls)
        obj.prime = int(prime)
        obj.digits = list(digits)
        obj.order = int(order)
        obj._originalNumerator = None
        obj._originalDenominator = None
        obj._padWithZeros(obj.digits)
        return obj

    def isZero(self) -> bool:
        """Check if the number is zero (represented by MAX_ORDER)."""
        return self.order == self.MAX_ORDER

    def _padWithZeros(self, list_: list[int]):
        """Pad or truncate the digit list to DIGITS_SIZE."""
        while len(list_) < self.DIGITS_SIZE:
            list_.append(0)
        if len(list_) > self.DIGITS_SIZE:
            del list_[self.DIGITS_SIZE:]

    def _negateDigits(self, digits: list[int]):
        """Negate a digit sequence in p-adic representation."""
        if not digits:
            return

        # First digit is negated differently than the rest
        digits[0] = (self.prime - digits[0]) % self.prime
        for i in range(1, len(digits)):
            digits[i] = (self.prime - 1 - digits[i]) % self.prime

    def negate(self) -> "PAdicSqrtNumber":
        """Return the additive inverse of the p-adic number."""
        if self.isZero():
            return self

        negated = list(self.digits)
        self._negateDigits(negated)

        return PAdicSqrtNumber.fromDigits(self.prime, negated, self.order)

    def multiply(self, other: "PAdicSqrtNumber") -> "PAdicSqrtNumber":
        """Multiply two p-adic numbers (with same prime)."""
        if self.prime != other.prime:
            raise ValueError("Cannot multiply p-adic's with different primes")
        if self.isZero() or other.isZero():
            return PAdicSqrtNumber.fromDigits(self.prime, [0]*self.DIGITS_SIZE, self.MAX_ORDER)
        productDigits = self._multiplyDigits(self.digits, other.digits)
        return PAdicSqrtNumber.fromDigits(self.prime, productDigits, self.order+other.order)

    def rational(self) -> str:
        """Attempt to reconstruct the rational number represented by this p-adic number."""
        if getattr(self, "_originalNumerator", None) is not None:
            return f"{self._originalNumerator} / {self._originalDenominator}"

        if self.isZero() or not self.digits:
            return "0 / 1"

        # Approximate rational via continued fraction reconstruction
        seriesSum = self.digits[0]
        pPow = 1
        for i in range(self.PRECISION):
            if i < len(self.digits):
                seriesSum += self.digits[i] * pPow
            pPow *= self.prime
        maximumPrime = self.prime ** self.PRECISION

        one = [maximumPrime, seriesSum]
        two = [0, 1]

        previousNorm = one[1] * one[1] + two[1] * two[1]
        currentNorm = previousNorm + 1
        i = 0
        j = 1

        # Euclidean-like reduction process
        while previousNorm < currentNorm:
            numerator = one[i] * one[j] + two[i] * two[j]
            denominator = previousNorm
            q = (numerator + (denominator // 2)) // denominator
            one[i] -= q * one[j]
            two[i] -= q * two[j]

            currentNorm = previousNorm
            previousNorm = one[i] * one[i] + two[i] * two[i]

            if previousNorm < currentNorm:
                i, j = j, i

        x = one[j]
        y = two[j]
        if y < 0:
            y = -y
            x = -x

        # Check validity of reconstruction
        if abs(one[i]*y-x*two[i]) != maximumPrime:
            raise AssertionError("Rational reconstruction failed")

        # Adjust by the valuation (order)
        if self.order < 0:
            for _ in range(-self.order):
                y *= self.prime
        else:
            for _ in range(self.order):
                x *= self.prime

        return f"{x} / {y}"

    def __str__(self) -> str:
        """String representation of the p-adic expansion."""
        if self.isZero() or not self.digits:
            return "...0.0".rjust(1)

        numbers = list(self.digits[:self.DIGITS_SIZE])
        self._padWithZeros(numbers)
        rev = "".join(str(d) for d in numbers[::-1])

        if self.order >= 0:
            body = rev + ("0" * self.order) + ".0"
        else:
            insertAt = len(rev) + self.order
            if insertAt <= 0:
                body = "0." + rev
            else:
                body = rev[:insertAt] + "." + rev[insertAt:]
            body = body.rstrip("0")
            if body.endswith("."):
                body += "0"

        tail = body[-(self.PRECISION+1):]
        return " ..." + tail

    def _multiplyDigits(self, one: list[int], two: list[int]) -> list[int]:
        """Multiply two p-adic digit arrays modulo prime."""
        product = [0] * (len(one) + len(two))

        for b in range(len(two)):
            carry = 0
            for a in range(len(one)):
                idx = a + b
                total = product[idx] + one[a] * two[b] + carry
                carry = total // self.prime
                product[idx] = total % self.prime
            product[b+len(one)] += carry

        result = product[:self.DIGITS_SIZE]
        if len(result) < self.DIGITS_SIZE:
            result += [0] * (self.DIGITS_SIZE - len(result))
        return result

    def _squareRootEvenPrime(self, numerator: int, denominator: int):
        """Compute square root when prime = 2."""
        if (numerator * denominator) % 8 != 1:
            raise AssertionError("Number does not have a square root in 2-adic")

        sum_ = 1
        self.digits = [0] * self.DIGITS_SIZE
        self.digits[0] = 1

        currentLen = 1
        while currentLen < self.DIGITS_SIZE:
            # Newton-like iteration for 2-adics
            factor = denominator * (sum_ * sum_) - numerator
            valuation = 0
            if factor == 0:
                valuation = self.DIGITS_SIZE
            else:
                while factor % 2 == 0 and valuation < self.DIGITS_SIZE + 5:
                    factor //= 2
                    valuation += 1

            if valuation - 1 >= 0:
                sum_ += 1 << (valuation - 1)
            else:
                sum_ += 0

            while currentLen < max(valuation-1, currentLen):
                if currentLen < self.DIGITS_SIZE:
                    self.digits[currentLen] = 0
                    currentLen += 1
                else:
                    break

            if currentLen < self.DIGITS_SIZE:
                self.digits[currentLen] = 1
                currentLen += 1
            else:
                break

        self._padWithZeros(self.digits)

    def _squareRootOddPrime(self, numerator: int, denominator: int):
        """Compute square root when prime is odd (Hensel lifting)."""
        p = self.prime
        firstDigit = 0

        # Find a solution modulo p
        for i in range(1, p):
            if ((denominator * (i * i) - numerator) % p) == 0:
                firstDigit = i
                break

        if firstDigit == 0:
            raise AssertionError(f"Number does not have a square root in {p}-adic")

        self.digits = [0] * self.DIGITS_SIZE
        self.digits[0] = firstDigit

        invMod = pow((2*denominator*firstDigit)%p, -1, p)

        s = firstDigit
        # Hensel lifting to higher powers of p
        for k in range(2, self.DIGITS_SIZE+1):
            mod_k = p ** k
            t = (denominator * (s * s) - numerator) % mod_k
            correction = (invMod * t) % mod_k
            next_s = (s - correction) % mod_k
            diff = (next_s - s) % mod_k
            digit = diff // (p ** (k - 1))
            idx = k - 1
            if idx < self.DIGITS_SIZE:
                self.digits[idx] = int(digit)
            s = (s + diff) % mod_k

        self._padWithZeros(self.digits)

if __name__ == "__main__":
    tests = [
        [2, 497, 10496],
        [3, 15403, 26685],
        [7, -19, 1]
    ]

    for p, num, den in tests:
        print(f"Number: {num} / {den} in {p}-adic")
        try:
            sqrt = PAdicSqrtNumber(p, num, den)
        except AssertionError as e:
            print("  No square root:", e)
            print()
            continue

        print("The two square roots are:")
        print("   ", sqrt)
        print("   ", sqrt.negate())
        sq = sqrt.multiply(sqrt)
        print("The p-adic value is", sq)
        try:
            print("The rational value is", sqrt.rational())
        except AssertionError as e:
            print("Rational reconstruction failed:", e)
        print()
