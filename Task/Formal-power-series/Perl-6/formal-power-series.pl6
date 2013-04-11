class DerFPS { ... }
class IntFPS { ... }

role FPS {
    method coeffs        { ... }
    method differentiate { DerFPS.new(:x(self)) }
    method integrate     { IntFPS.new(:x(self)) }

    method pretty($n) {
        sub super($i) { $i.trans('0123456789' => '⁰¹²³⁴⁵⁶⁷⁸⁹') }
        my $str = $.coeffs[0].perl;
        for 1..$n Z $.coeffs[1..$n] -> $i, $_ {
            when * > 0 { $str ~= " + {(+$_).perl}∙x{super($i)}" }
            when * < 0 { $str ~= " - {(-$_).perl}∙x{super($i)}" }
        }
        $str;
    }
}

class ExplicitFPS does FPS { has @.coeffs }

class SumFPS does FPS {
    has FPS ($.x, $.y);
    method coeffs { $.x.coeffs Z+ $.y.coeffs }
}

class DifFPS does FPS {
    has FPS ($.x, $.y);
    method coeffs { $.x.coeffs Z- $.y.coeffs }
}

class ProFPS does FPS {
    has FPS ($.x, $.y);
    method coeffs { (0..*).map: { [+] ($.x.coeffs[0..$_] Z* $.y.coeffs[$_...0]) } }
}

class InvFPS does FPS {
    has FPS $.x;
    method coeffs {
        # see http://en.wikipedia.org/wiki/Formal_power_series#Inverting_series
        gather {
            my @a := $.x.coeffs;
            @a[0] != 0 or fail "Cannot invert power series with zero constant term.";
            take my @b = (1 / @a[0]);
            take @b[$_] = -@b[0] * [+] (@a[1..$_] Z* @b[$_-1...0]) for 1..*;
        }
    }
}

class DerFPS does FPS {
    has FPS $.x;
    method coeffs { (1..*).map: { $_ * $.x.coeffs[$_] } }
}

class IntFPS does FPS {
    has FPS $.x;
    method coeffs { 0, (0..*).map: { $.x.coeffs[$_] / ($_+1) } }
}

class DeferredFPS does FPS {
    has FPS $.realized is rw;
    method coeffs { $.realized.coeffs }
}

# some arithmetic operations for formal power series
multi infix:<+>(FPS $x, FPS $y) { SumFPS.new(:$x, :$y) }
multi infix:<->(FPS $x, FPS $y) { DifFPS.new(:$x, :$y) }
multi infix:<*>(FPS $x, FPS $y) { ProFPS.new(:$x, :$y) }
multi infix:</>(FPS $x, FPS $y) { $x * InvFPS.new(:x($y)) }

# an example of a mixed-type operator:
multi infix:<->(Numeric $x, FPS $y) { ExplicitFPS.new(:coeffs($x, 0 xx *)) - $y }

# define sine and cosine in terms of each other
my $sin       = DeferredFPS.new;
my $cos       = 1 - $sin.integrate;
$sin.realized = $cos.integrate;

# define tangent in terms of sine and cosine
my $tan       = $sin / $cos;

say 'sin(x) ≈ ', $sin.pretty(10);
say 'cos(x) ≈ ', $cos.pretty(10);
say 'tan(x) ≈ ', $tan.pretty(10);
