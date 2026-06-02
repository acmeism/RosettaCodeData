/* rat.zc */

import "std/string.zc"

fn gcd(x: i64, y: i64) -> i64 {
    while y {
        let t = y;
        y = x % y;
        x = t;
    }
    return labs(x);
}

@derive(Copy)
struct Rat {
    num: i64;
    den: i64;
}

impl Rat {
    // Creates a new Rat struct in canonical form
    // i.e. n and d have no common factors and d > 0.
    // The Rat struct should not be created directly
    // unless you're certain it's already in such a form.
    fn new(n: i64, d: i64 = 1) -> Self {
        assert(d != 0, "Denominator must be non-zero.");
        if n == 0 {
            d = 1;
        } else if d < 0 {
            n = -n;
            d = -d;
        }
        if labs(n) != 1 && d > 1 {
            let g = gcd(n, d);
            if g > 1 {
                n /= g;
                d /= g;
            }
        }
        return Rat{num: n, den: d};
    }

    fn neg(self) -> Rat {
        return Rat{num: -self.num, den: self.den};
    }

    fn add(self, other: Rat) -> Rat {
        return Rat::new(
            self.num * other.den + self.den * other.num,
            self.den * other.den
        );
    }

    fn sub(self, other: Rat) -> Rat {
        return *self + (-other);
    }

    fn mul(self, other: Rat) -> Rat {
        return Rat::new(
            self.num * other.num,
            self.den * other.den
        );
    }

    fn div(self, other: Rat) -> Rat {
        return Rat::new(
            self.num * other.den,
            self.den * other.num
        );
    }

    fn trunc(self) -> Rat {
        return Rat{num: self.num / self.den, den: 1};
    }

    fn ceil(self) -> Rat {
        if self.den == 1 return self.clone();
        return self.num >= 0 ? self.trunc().inc() : self.trunc();
    }

    fn floor(self) -> Rat {
        if self.den == 1 return self.clone();
        return self.num >= 0 ? self.trunc() : self.trunc().dec();
    }

    fn round(self) -> Rat {
        if self.num >= 0 { return (*self + Rat{num: 1, den: 2}).trunc(); }
        return (*self - Rat{num: 1, den: 2}).trunc();
    }

    fn frac(self) -> Rat {
        return *self - self.trunc();
    }

    fn idiv(self, other: Rat) -> Rat {
        return (*self / other).trunc();
    }

    fn rem(self, other: Rat) -> Rat {
        return *self - self.idiv(other) * other;
    }

    fn pow(self, exp: int) -> Rat {
        let r = Rat{num: self.num ** abs(exp), den: self.den ** abs(exp)};
        return exp >= 0 ? r : r.inv();
    }

    fn inv(self) -> Rat {
        return Rat::new(self.den, self.num);
    }

    fn abs(self) -> Rat {
        return Rat{num: labs(self.num), den: self.den};
    }

    fn inc(self) -> Rat {
        return Rat{num: self.num + self.den, den: self.den};
    }

    fn dec(self) -> Rat {
        return Rat{num: self.num - self.den, den: self.den};
    }

    fn sign(self) -> int {
        return self.num > 0 ? 1 : self.num < 0 ? -1 : 0;
    }

    fn eq(self, other: Rat) -> bool {
        return self.num == other.num && self.den == other.den;
    }

    fn neq(self, other: Rat) -> bool {
        return !self.eq(other);
    }

    fn lt(self, other: Rat) -> bool {
        return (*self - other).num < 0;
    }

    fn gt(self, other: Rat) -> bool {
        return (*self - other).num > 0;
    }

    fn le(self, other: Rat) -> bool {
        return (*self - other).num <= 0;
    }

    fn ge(self, other: Rat) -> bool {
        return (*self - other).num >= 0;
    }

    fn to_f64(self) -> f64 {
        return (f64)self.num / (f64)self.den;
    }

    fn to_i64(self) -> i64 {
        return self.trunc().num;
    }

    fn to_string(self) -> String {
        let s = .den > 1 ? "{self.num:ld} / {self.den:ld}" : "{self.num:ld}";
        return String::from(s);
    }

    fn max(r1: Rat, r2: Rat) -> Rat {
        return r1 < r2 ? r2 : r1;
    }

    fn min(r1: Rat, r2: Rat) -> Rat {
        return r1 < r2 ? r1 : r2;
    }
}

impl Clone for Rat {
    fn clone(self) -> Rat {
        return Rat{num: self.num, den: self.den};
    }
}
