class EllipticCurveDigitalSignatureAlgorithm {
  static main() {
    // Test parameters for elliptic curve digital signature algorithm,
    // using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
    //
    // Parameter: a, b, modulus N, base point G, order of G in the elliptic curve.

    const parameters = [
      new Parameter(355, 671, 1073741789, new Point(13693, 10088), 1073807281),
      new Parameter(0, 7, 67096021, new Point(6580, 779), 16769911),
      new Parameter(-3, 1, 877073, new Point(0, 1), 878159),
      new Parameter(0, 14, 22651, new Point(63, 30), 151),
      new Parameter(3, 2, 5, new Point(2, 1), 5),
    ];

    // Parameters which cause failure of the algorithm for the given reasons
    // the base point is of composite order
    // new Parameter(   0,   7,   67096021, new Point( 2402,  6067),   33539822 ),
    // the given order is of composite order
    // new Parameter(   0,   7,   67096021, new Point( 6580,   779),   67079644 ),
    // the modulus is not prime (deceptive example)
    // new Parameter(   0,   7,     877069, new Point(    3, 97123),     877069 ),
    // fails if the modulus divides the discriminant
    // new Parameter(  39, 387,      22651, new Point(   95,    27),      22651 ) );

    const f = 0x789abcde; // The message's digital signature hash which is to be verified
    const d = 0; // Set d > 0 to simulate corrupted data

    for (const parameter of parameters) {
      const ellipticCurve = new EllipticCurve(parameter);
      EllipticCurveDigitalSignatureAlgorithm.ecdsa(ellipticCurve, f, d);
    }
  }

  // Build the digital signature for a message using the hash aF with error bit aD
  static ecdsa(aCurve, aF, aD) {
    let point = aCurve.multiply(aCurve.g, aCurve.r);

    if (
      aCurve.discriminant() == 0 ||
      aCurve.g.isZero() ||
      !point.isZero() ||
      !aCurve.contains(aCurve.g)
    ) {
      //throw new Error("Invalid parameter in method ecdsa");
    }

    console.log("\nkey generation");
    const s = 1 + Math.floor(Math.random() * (aCurve.r - 1));
    point = aCurve.multiply(aCurve.g, s);
    console.log("private key s = " + s);
    aCurve.printPointWithPrefix(point, "public key W = sG");

    // Find the next highest power of two minus one.
    let t = aCurve.r;
    let i = 1;
    while (i < 64) {
      t |= t >> i;
      i <<= 1;
    }
    let f = aF;
    while (f > t) {
      f >>= 1;
    }
    console.log("\naligned hash " + f.toString(16).padStart(8, '0'));

    const signature = EllipticCurveDigitalSignatureAlgorithm.signature(
      aCurve,
      s,
      f
    );
    console.log("signature c, d = " + signature.a + ", " + signature.b);

    let d = aD;
    if (d > 0) {
      while (d > t) {
        d >>= 1;
      }
      f ^= d;
      console.log("\ncorrupted hash " + f.toString(16).padStart(8, '0'));
    }

    console.log(
      EllipticCurveDigitalSignatureAlgorithm.verify(aCurve, point, f, signature)
        ? "Valid"
        : "Invalid"
    );
    console.log("-----------------");
  }

  static verify(aCurve, aPoint, aF, aSignature) {
    if (
      aSignature.a < 1 ||
      aSignature.a >= aCurve.r ||
      aSignature.b < 1 ||
      aSignature.b >= aCurve.r
    ) {
      return false;
    }

    console.log("\nsignature verification");
    const h = EllipticCurveDigitalSignatureAlgorithm.extendedGCD(
      aSignature.b,
      aCurve.r
    );
    const h1 = EllipticCurveDigitalSignatureAlgorithm.floorMod(aF * h, aCurve.r);
    const h2 = EllipticCurveDigitalSignatureAlgorithm.floorMod(aSignature.a * h, aCurve.r);
    console.log("h1, h2 = " + h1 + ", " + h2);
    let v = aCurve.multiply(aCurve.g, h1);
    let v2 = aCurve.multiply(aPoint, h2);
    aCurve.printPointWithPrefix(v, "h1G");
    aCurve.printPointWithPrefix(v2, "h2W");
    v = aCurve.add(v, v2);
    aCurve.printPointWithPrefix(v, "+ =");

    if (v.isZero()) {
      return false;
    }
    const c1 = EllipticCurveDigitalSignatureAlgorithm.floorMod(v.x, aCurve.r);
    console.log("c' = " + c1);
    return c1 == aSignature.a;
  }

  static signature(aCurve, aS, aF) {
    let c = 0;
    let d = 0;
    let u;
    let v;
    console.log("Signature computation");

    while (true) {
      while (true) {
        u = 1 + Math.floor(Math.random() * (aCurve.r - 1));
        v = aCurve.multiply(aCurve.g, u);
        c = EllipticCurveDigitalSignatureAlgorithm.floorMod(v.x, aCurve.r);
        if (c != 0) {
          break;
        }
      }

      d = EllipticCurveDigitalSignatureAlgorithm.floorMod(
        EllipticCurveDigitalSignatureAlgorithm.extendedGCD(u, aCurve.r) *
          EllipticCurveDigitalSignatureAlgorithm.floorMod(aF + aS * c, aCurve.r),
        aCurve.r
      );
      if (d != 0) {
        break;
      }
    }

    console.log("one-time u = " + u);
    aCurve.printPointWithPrefix(v, "V = uG");
    return new Pair(c, d);
  }

  // Return 1 / aV modulus aU
  static extendedGCD(aV, aU) {
    if (aV < 0) {
      aV += aU;
    }

    let result = 0;
    let s = 1;
    while (aV != 0) {
      const quotient = Math.floor(aU / aV);
      aU = EllipticCurveDigitalSignatureAlgorithm.floorMod(aU, aV);
      let temp = aU;
      aU = aV;
      aV = temp;
      result -= quotient * s;
      temp = result;
      result = s;
      s = temp;
    }

    if (aU != 1) {
      throw new Error("Cannot inverse modulo N, gcd = " + aU);
    }
    return result;
  }

  static floorMod(x, y) {
    return ((x % y) + y) % y;
  }

  // static random() {
  //   return Math.random();
  // }
}

class EllipticCurve {
  constructor(aParameter) {
    this.n = aParameter.n;
    if (this.n < 5 || this.n > EllipticCurveDigitalSignatureAlgorithm.MAX_MODULUS) {
      throw new Error("Invalid value for modulus: " + this.n);
    }

    this.a = EllipticCurveDigitalSignatureAlgorithm.floorMod(aParameter.a, this.n);
    this.b = EllipticCurveDigitalSignatureAlgorithm.floorMod(aParameter.b, this.n);
    this.g = aParameter.g;
    this.r = aParameter.r;

    if (this.r < 5 || this.r > EllipticCurveDigitalSignatureAlgorithm.MAX_ORDER_G) {
      throw new Error("Invalid value for the order of g: " + this.r);
    }

    console.log();
    console.log(
      "Elliptic curve: y^2 = x^3 + " +
        this.a +
        "x + " +
        this.b +
        " (mod " +
        this.n +
        ")"
    );
    this.printPointWithPrefix(this.g, "base point G");
    console.log("order(G, E) = " + this.r);
  }

  add(aP, aQ) {
    if (aP.isZero()) {
      return aQ;
    }
    if (aQ.isZero()) {
      return aP;
    }

    let la;
    if (aP.x != aQ.x) {
      la = EllipticCurveDigitalSignatureAlgorithm.floorMod(
        (aP.y - aQ.y) *
          EllipticCurveDigitalSignatureAlgorithm.extendedGCD(aP.x - aQ.x, this.n),
        this.n
      );
    } else if (aP.y == aQ.y && aP.y != 0) {
      la = EllipticCurveDigitalSignatureAlgorithm.floorMod(
        EllipticCurveDigitalSignatureAlgorithm.floorMod(
          EllipticCurveDigitalSignatureAlgorithm.floorMod(aP.x * aP.x, this.n) * 3 +
            this.a,
          this.n
        ) * EllipticCurveDigitalSignatureAlgorithm.extendedGCD(2 * aP.y, this.n),
        this.n
      );
    } else {
      return Point.ZERO;
    }

    const xCoordinate = EllipticCurveDigitalSignatureAlgorithm.floorMod(
      la * la - aP.x - aQ.x,
      this.n
    );
    const yCoordinate = EllipticCurveDigitalSignatureAlgorithm.floorMod(
      la * (aP.x - xCoordinate) - aP.y,
      this.n
    );
    return new Point(xCoordinate, yCoordinate);
  }

  multiply(aPoint, aK) {
    let result = Point.ZERO;

    while (aK != 0) {
      if ((aK & 1) == 1) {
        result = this.add(result, aPoint);
      }
      aPoint = this.add(aPoint, aPoint);
      aK >>= 1;
    }
    return result;
  }

  contains(aPoint) {
    if (aPoint.isZero()) {
      return true;
    }

    const r = EllipticCurveDigitalSignatureAlgorithm.floorMod(
      EllipticCurveDigitalSignatureAlgorithm.floorMod(
        this.a + aPoint.x * aPoint.x,
        this.n
      ) * aPoint.x + this.b,
      this.n
    );
    const s = EllipticCurveDigitalSignatureAlgorithm.floorMod(aPoint.y * aPoint.y, this.n);
    return r == s;
  }

  discriminant() {
    const constant =
      4 *
      EllipticCurveDigitalSignatureAlgorithm.floorMod(
        this.a * this.a,
        this.n
      ) *
      EllipticCurveDigitalSignatureAlgorithm.floorMod(this.a, this.n);
    return EllipticCurveDigitalSignatureAlgorithm.floorMod(
      -16 *
        (EllipticCurveDigitalSignatureAlgorithm.floorMod(this.b * this.b, this.n) *
          27 +
          constant),
      this.n
    );
  }

  printPointWithPrefix(aPoint, aPrefix) {
    let y = aPoint.y;
    if (aPoint.isZero()) {
      console.log(aPrefix + " (0)");
    } else {
      if (y > this.n - y) {
        y -= this.n;
      }
      console.log(aPrefix + " (" + aPoint.x + ", " + y + ")");
    }
  }
}

class Point {
  constructor(aX, aY) {
    this.x = aX;
    this.y = aY;
  }

  isZero() {
    return this.x == Point.INFINITY && this.y == 0;
  }
}

class Pair {
  constructor(a, b) {
    this.a = a;
    this.b = b;
  }
}

class Parameter {
  constructor(a, b, n, g, r) {
    this.a = a;
    this.b = b;
    this.n = n;
    this.g = g;
    this.r = r;
  }
}

Point.INFINITY = Number.MAX_SAFE_INTEGER;
Point.ZERO = new Point(Point.INFINITY, 0);

EllipticCurveDigitalSignatureAlgorithm.MAX_MODULUS = 1073741789;
EllipticCurveDigitalSignatureAlgorithm.MAX_ORDER_G =
  EllipticCurveDigitalSignatureAlgorithm.MAX_MODULUS + 65536;

// EllipticCurveDigitalSignatureAlgorithm.RANDOM = Math.random();

EllipticCurveDigitalSignatureAlgorithm.main();
