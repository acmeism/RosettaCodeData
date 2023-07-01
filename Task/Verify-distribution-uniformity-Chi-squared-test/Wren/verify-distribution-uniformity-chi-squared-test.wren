import "/math" for Math, Nums
import "/fmt" for Fmt

var integrate = Fn.new { |a, b, n, f|
    var h = (b - a) / n
    var sum = 0
    for (i in 0...n) {
        var x = a + i*h
        sum = sum + (f.call(x) + 4 * f.call(x + h/2) + f.call(x + h)) / 6
    }
    return sum * h
}

var gammaIncomplete = Fn.new { |a, x|
    var am1 = a - 1
    var f0 = Fn.new { |t| t.pow(am1) * (-t).exp }
    var h = 1.5e-2
    var y = am1
    while ((f0.call(y) * (x - y) > 2e-8) && y < x) y = y + 0.4
    if (y > x) y = x
    return 1 - integrate.call(0, y, (y/h).truncate, f0) / Math.gamma(a)
}

var chi2UniformDistance = Fn.new { |ds|
    var expected = Nums.mean(ds)
    var sum = Nums.sum(ds.map { |d| (d - expected).pow(2) }.toList)
    return sum / expected
}

var chi2Probability = Fn.new { |dof, dist| gammaIncomplete.call(0.5*dof, 0.5*dist) }

var chiIsUniform = Fn.new { |ds, significance|
    var dof = ds.count - 1
    var dist = chi2UniformDistance.call(ds)
    return chi2Probability.call(dof, dist) > significance
}

var dsets = [
    [199809, 200665, 199607, 200270, 199649],
    [522573, 244456, 139979,  71531,  21461]
]
for (ds in dsets) {
    System.print("Dataset: %(ds)")
    var dist = chi2UniformDistance.call(ds)
    var dof = ds.count - 1
    Fmt.write("DOF: $d  Distance: $.4f", dof, dist)
    var prob = chi2Probability.call(dof, dist)
    Fmt.write("  Probability: $.6f", prob)
    var uniform = chiIsUniform.call(ds, 0.05) ? "Yes" : "No"
    System.print("  Uniform? %(uniform)\n")
}
