import math

type Ifctn = fn(f64) f64

fn simpson38(f Ifctn, a f64, b f64, n int) f64 {
    h := (b - a) / f64(n)
    h1 := h / 3
    mut sum := f(a) + f(b)
    for j := 3*n - 1; j > 0; j-- {
        if j%3 == 0 {
            sum += 2 * f(a+h1*f64(j))
        } else {
            sum += 3 * f(a+h1*f64(j))
        }
    }
    return h * sum / 8
}

fn gamma_inc_q(a f64, x f64) f64 {
    aa1 := a - 1
    f := Ifctn(fn[aa1](t f64) f64 {
        return math.pow(t, aa1) * math.exp(-t)
    })
    mut y := aa1
    h := 1.5e-2
    for f(y)*(x-y) > 2e-8 && y < x {
        y += .4
    }
    if y > x {
        y = x
    }
    return 1 - simpson38(f, 0, y, int(y/h/math.gamma(a)))
}

fn chi2ud(ds []int) f64 {
    mut sum, mut expected := 0.0,0.0
    for d in ds {
        expected += f64(d)
    }
    expected /= f64(ds.len)
    for d in ds {
        x := f64(d) - expected
        sum += x * x
    }
    return sum / expected
}

fn chi2p(dof int, distance f64) f64 {
    return gamma_inc_q(.5*f64(dof), .5*distance)
}

const sig_level = .05

fn main() {
    for dset in [
        [199809, 200665, 199607, 200270, 199649],
        [522573, 244456, 139979, 71531, 21461],
     ] {
        utest(dset)
    }
}

fn utest(dset []int) {
    println("Uniform distribution test")
    mut sum := 0
    for c in dset {
        sum += c
    }
    println(" dataset: $dset")
    println(" samples:                      $sum")
    println(" categories:                   $dset.len")

    dof := dset.len - 1
    println(" degrees of freedom:           $dof")

    dist := chi2ud(dset)
    println(" chi square test statistic:    $dist")

    p := chi2p(dof, dist)
    println(" p-value of test statistic:    $p")

    sig := p < sig_level
    println(" significant at ${sig_level*100:2.0f}% level?     $sig")
    println(" uniform?                      ${!sig}\n")
}
