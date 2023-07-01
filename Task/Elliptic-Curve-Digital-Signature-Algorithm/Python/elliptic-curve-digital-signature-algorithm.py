from collections import namedtuple
from hashlib import sha256
from math import ceil, log
from random import randint
from typing import NamedTuple

# Bitcoin ECDSA curve
secp256k1_data = dict(
    p=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F,  # Field characteristic
    a=0x0,  # Curve param a
    b=0x7,  # Curve param b
    r=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141,  # Order n of basepoint G. Cofactor is 1 so it's ommited.
    Gx=0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,  # Base point x
    Gy=0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,  # Base point y
)
secp256k1 = namedtuple("secp256k1", secp256k1_data)(**secp256k1_data)
assert (secp256k1.Gy ** 2 - secp256k1.Gx ** 3 - 7) % secp256k1.p == 0


class CurveFP(NamedTuple):
    p: int  # Field characteristic
    a: int  # Curve param a
    b: int  # Curve param b


def extended_gcd(aa, bb):
    # https://rosettacode.org/wiki/Modular_inverse#Iteration_and_error-handling
    lastremainder, remainder = abs(aa), abs(bb)
    x, lastx, y, lasty = 0, 1, 1, 0
    while remainder:
        lastremainder, (quotient, remainder) = remainder, divmod(
            lastremainder, remainder
        )
        x, lastx = lastx - quotient * x, x
        y, lasty = lasty - quotient * y, y
    return lastremainder, lastx * (-1 if aa < 0 else 1), lasty * (-1 if bb < 0 else 1)


def modinv(a, m):
    # https://rosettacode.org/wiki/Modular_inverse#Iteration_and_error-handling
    g, x, _ = extended_gcd(a, m)
    if g != 1:
        raise ValueError
    return x % m


class PointEC(NamedTuple):
    curve: CurveFP
    x: int
    y: int

    @classmethod
    def build(cls, curve, x, y):
        x = x % curve.p
        y = y % curve.p
        rv = cls(curve, x, y)
        if not rv.is_identity():
            assert rv.in_curve()
        return rv

    def get_identity(self):
        return PointEC.build(self.curve, 0, 0)

    def copy(self):
        return PointEC.build(self.curve, self.x, self.y)

    def __neg__(self):
        return PointEC.build(self.curve, self.x, -self.y)

    def __sub__(self, Q):
        return self + (-Q)

    def __equals__(self, Q):
        # TODO: Assert same curve or implement logic for that.
        return self.x == Q.x and self.y == Q.y

    def is_identity(self):
        return self.x == 0 and self.y == 0

    def __add__(self, Q):
        # TODO: Assert same curve or implement logic for that.
        p = self.curve.p
        if self.is_identity():
            return Q.copy()
        if Q.is_identity():
            return self.copy()
        if Q.x == self.x and (Q.y == (-self.y % p)):
            return self.get_identity()

        if self != Q:
            l = ((Q.y - self.y) * modinv(Q.x - self.x, p)) % p
        else:
            # Point doubling.
            l = ((3 * self.x ** 2 + self.curve.a) * modinv(2 * self.y, p)) % p
        l = int(l)

        Rx = (l ** 2 - self.x - Q.x) % p
        Ry = (l * (self.x - Rx) - self.y) % p
        rv = PointEC.build(self.curve, Rx, Ry)
        return rv

    def in_curve(self):
        return ((self.y ** 2) % self.curve.p) == (
            (self.x ** 3 + self.curve.a * self.x + self.curve.b) % self.curve.p
        )

    def __mul__(self, s):
        # Naive method is exponential (due to invmod right?) so we use an alternative method:
        # https://en.wikipedia.org/wiki/Elliptic_curve_point_multiplication#Montgomery_ladder
        r0 = self.get_identity()
        r1 = self.copy()
        # pdbsas
        for i in range(ceil(log(s + 1, 2)) - 1, -1, -1):
            if ((s & (1 << i)) >> i) == 0:
                r1 = r0 + r1
                r0 = r0 + r0
            else:
                r0 = r0 + r1
                r1 = r1 + r1
        return r0

    def __rmul__(self, other):
        return self.__mul__(other)


class ECCSetup(NamedTuple):
    E: CurveFP
    G: PointEC
    r: int


secp256k1_curve = CurveFP(secp256k1.p, secp256k1.a, secp256k1.b)
secp256k1_basepoint = PointEC(secp256k1_curve, secp256k1.Gx, secp256k1.Gy)


class ECDSAPrivKey(NamedTuple):
    ecc_setup: ECCSetup
    secret: int

    def get_pubkey(self):
        # Compute W = sG to get the pubkey
        W = self.secret * self.ecc_setup.G
        pub = ECDSAPubKey(self.ecc_setup, W)
        return pub


class ECDSAPubKey(NamedTuple):
    ecc_setup: ECCSetup
    W: PointEC


class ECDSASignature(NamedTuple):
    c: int
    d: int


def generate_keypair(ecc_setup, s=None):
    # Select a random integer s in the interval [1, r - 1] for the secret.
    if s is None:
        s = randint(1, ecc_setup.r - 1)
    priv = ECDSAPrivKey(ecc_setup, s)
    pub = priv.get_pubkey()
    return priv, pub


def get_msg_hash(msg):
    return int.from_bytes(sha256(msg).digest(), "big")


def sign(priv, msg, u=None):
    G = priv.ecc_setup.G
    r = priv.ecc_setup.r

    # 1. Compute message representative f = H(m), using a cryptographic hash function.
    #    Note that f can be greater than r but not longer (measuring bits).
    msg_hash = get_msg_hash(msg)

    while True:
        # 2. Select a random integer u in the interval [1, r - 1].
        if u is None:
            u = randint(1, r - 1)

        # 3. Compute V = uG = (xV, yV) and c ≡ xV mod r  (goto (2) if c = 0).
        V = u * G
        c = V.x % r
        if c == 0:
            print(f"c={c}")
            continue
        d = (modinv(u, r) * (msg_hash + priv.secret * c)) % r
        if d == 0:
            print(f"d={d}")
            continue
        break

    signature = ECDSASignature(c, d)
    return signature


def verify_signature(pub, msg, signature):
    r = pub.ecc_setup.r
    G = pub.ecc_setup.G
    c = signature.c
    d = signature.d

    # Verify that c and d are integers in the interval [1, r - 1].
    def num_ok(n):
        return 1 < n < (r - 1)

    if not num_ok(c):
        raise ValueError(f"Invalid signature value: c={c}")
    if not num_ok(d):
        raise ValueError(f"Invalid signature value: d={d}")

    # Compute f = H(m) and h ≡ d^-1 mod r.
    msg_hash = get_msg_hash(msg)
    h = modinv(d, r)

    # Compute h1 ≡ f·h mod r and h2 ≡ c·h mod r.
    h1 = (msg_hash * h) % r
    h2 = (c * h) % r

    # Compute h1G + h2W = (x1, y1) and c1 ≡ x1 mod r.
    # Accept the signature if and only if c1 = c.
    P = h1 * G + h2 * pub.W
    c1 = P.x % r
    rv = c1 == c
    return rv


def get_ecc_setup(curve=None, basepoint=None, r=None):
    if curve is None:
        curve = secp256k1_curve
    if basepoint is None:
        basepoint = secp256k1_basepoint
    if r is None:
        r = secp256k1.r

    # 1. Select an elliptic curve E defined over ℤp.
    #    The number of points in E(ℤp) should be divisible by a large prime r.
    E = CurveFP(curve.p, curve.a, curve.b)

    # 2. Select a base point G ∈ E(ℤp) of order r (which means that rG = 𝒪).
    G = PointEC(E, basepoint.x, basepoint.y)
    assert (G * r) == G.get_identity()

    ecc_setup = ECCSetup(E, G, r)
    return ecc_setup


def main():
    ecc_setup = get_ecc_setup()
    print(f"E: y^2 = x^3 + {ecc_setup.E.a}x + {ecc_setup.E.b} (mod {ecc_setup.E.p})")
    print(f"base point G({ecc_setup.G.x}, {ecc_setup.G.y})")
    print(f"order(G, E) = {ecc_setup.r}")

    print("Generating keys")
    priv, pub = generate_keypair(ecc_setup)
    print(f"private key s = {priv.secret}")
    print(f"public key W = sG ({pub.W.x}, {pub.W.y})")

    msg_orig = b"hello world"
    signature = sign(priv, msg_orig)
    print(f"signature ({msg_orig}, priv) = (c,d) = {signature.c}, {signature.d}")

    validation = verify_signature(pub, msg_orig, signature)
    print(f"verify_signature(pub, {msg_orig}, signature) = {validation}")

    msg_bad = b"hello planet"
    validation = verify_signature(pub, msg_bad, signature)
    print(f"verify_signature(pub, {msg_bad}, signature) = {validation}")


if __name__ == "__main__":
    main()
