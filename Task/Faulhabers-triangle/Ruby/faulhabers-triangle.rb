class Frac
    attr_accessor:num
    attr_accessor:denom

    def initialize(n,d)
        if d == 0 then
            raise ArgumentError.new('d cannot be zero')
        end

        nn = n
        dd = d
        if nn == 0 then
            dd = 1
        elsif dd < 0 then
            nn = -nn
            dd = -dd
        end

        g = nn.abs.gcd(dd.abs)
        if g > 1 then
            nn = nn / g
            dd = dd / g
        end

        @num = nn
        @denom = dd
    end

    def to_s
        if self.denom == 1 then
            return self.num.to_s
        else
            return "%d/%d" % [self.num, self.denom]
        end
    end

    def -@
        return Frac.new(-self.num, self.denom)
    end

    def +(rhs)
        return Frac.new(self.num * rhs.denom + self.denom * rhs.num, rhs.denom * self.denom)
    end
    def -(rhs)
        return Frac.new(self.num * rhs.denom - self.denom * rhs.num, rhs.denom * self.denom)
    end

    def *(rhs)
        return Frac.new(self.num * rhs.num, rhs.denom * self.denom)
    end
end

FRAC_ZERO = Frac.new(0, 1)
FRAC_ONE  = Frac.new(1, 1)

def bernoulli(n)
    if n < 0 then
        raise ArgumentError.new('n cannot be negative')
    end

    a = Array.new(n + 1)
    a[0] = FRAC_ZERO

    for m in 0 .. n do
        a[m] = Frac.new(1, m + 1)
        m.downto(1) do |j|
            a[j - 1] = (a[j - 1] - a[j]) * Frac.new(j, 1)
        end
    end

    if n != 1 then
        return a[0]
    end
    return -a[0]
end

def binomial(n, k)
    if n < 0 then
        raise ArgumentError.new('n cannot be negative')
    end
    if k < 0 then
        raise ArgumentError.new('k cannot be negative')
    end
    if n < k then
        raise ArgumentError.new('n cannot be less than k')
    end

    if n == 0 or k == 0 then
        return 1
    end

    num = 1
    for i in k + 1 .. n do
        num = num * i
    end

    den = 1
    for i in 2 .. n - k do
        den = den * i
    end

    return num / den
end

def faulhaberTriangle(p)
    coeffs = Array.new(p + 1)
    coeffs[0] = FRAC_ZERO
    q = Frac.new(1, p + 1)
    sign = -1
    for j in 0 .. p do
        sign = -sign
        coeffs[p - j] = q * Frac.new(sign, 1) * Frac.new(binomial(p + 1, j), 1) * bernoulli(j)
    end
    return coeffs
end

def main
    for i in 0 .. 9 do
        coeffs = faulhaberTriangle(i)
        coeffs.each do |coeff|
            print "%5s  " % [coeff]
        end
        puts
    end
end

main()
