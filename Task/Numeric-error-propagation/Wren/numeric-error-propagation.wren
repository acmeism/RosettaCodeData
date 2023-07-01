class Approx {
    construct new(nu, sigma) {
        _nu = nu
        _sigma = sigma
    }

    static new(a) {
        if (a is Approx) return Approx.new(a.nu, a.sigma)
        if (a is Num)    return Approx.new(a, 0)
    }

    nu    { _nu }
    sigma { _sigma }

    +(a) {
        if (a is Approx) return Approx.new(_nu + a.nu, (_sigma *_sigma + a.sigma*a.sigma).sqrt)
        if (a is Num)    return Approx.new(_nu + a, _sigma)
    }

    -(a) {
        if (a is Approx) return Approx.new(_nu - a.nu, (_sigma *_sigma + a.sigma*a.sigma).sqrt)
        if (a is Num)    return Approx.new(_nu - a, _sigma)
    }

    *(a) {
        if (a is Approx) {
            var v = _nu * a.nu
            return Approx.new(v, (v*v*_sigma*_sigma/(_nu*_nu) + a.sigma*a.sigma/(a.nu*a.nu)).sqrt)
        }
        if (a is Num) return Approx.new(_nu*a, (a*_sigma).abs)
    }

    /(a) {
        if (a is Approx) {
            var v = _nu / a.nu
            return Approx.new(v, (v*v*_sigma*_sigma/(_nu*_nu) + a.sigma*a.sigma/(a.nu*a.nu)).sqrt)
        }
        if (a is Num) return Approx.new(_nu/a, (a*_sigma).abs)
    }

    pow(d) {
        var v = _nu.pow(d)
        return Approx.new(v, (v*d*_sigma/_nu).abs)
    }

    toString { "%(_nu) ±%(_sigma)" }
}

var x1 = Approx.new(100, 1.1)
var y1 = Approx.new( 50, 1.2)
var x2 = Approx.new(200, 2.2)
var y2 = Approx.new(100, 2.3)
System.print(((x1 - x2).pow(2) + (y1 - y2).pow(2)).pow(0.5))
