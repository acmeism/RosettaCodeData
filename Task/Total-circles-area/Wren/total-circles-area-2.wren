import "/dynamic" for Tuple
import "/math" for Nums
import "/sort" for Sort

var Point  = Tuple.create("Point", ["x", "y"])
var Circle = Tuple.create("Circle", ["x", "y", "r"])

var circles = [
    Circle.new( 1.6417233788,  1.6121789534, 0.0848270516),
    Circle.new(-1.4944608174,  1.2077959613, 1.1039549836),
    Circle.new( 0.6110294452, -0.6907087527, 0.9089162485),
    Circle.new( 0.3844862411,  0.2923344616, 0.2375743054),
    Circle.new(-0.2495892950, -0.3832854473, 1.0845181219),
    Circle.new( 1.7813504266,  1.6178237031, 0.8162655711),
    Circle.new(-0.1985249206, -0.8343333301, 0.0538864941),
    Circle.new(-1.7011985145, -0.1263820964, 0.4776976918),
    Circle.new(-0.4319462812,  1.4104420482, 0.7886291537),
    Circle.new( 0.2178372997, -0.9499557344, 0.0357871187),
    Circle.new(-0.6294854565, -1.3078893852, 0.7653357688),
    Circle.new( 1.7952608455,  0.6281269104, 0.2727652452),
    Circle.new( 1.4168575317,  1.0683357171, 1.1016025378),
    Circle.new( 1.4637371396,  0.9463877418, 1.1846214562),
    Circle.new(-0.5263668798,  1.7315156631, 1.4428514068),
    Circle.new(-1.2197352481,  0.9144146579, 1.0727263474),
    Circle.new(-0.1389358881,  0.1092805780, 0.7350208828),
    Circle.new( 1.5293954595,  0.0030278255, 1.2472867347),
    Circle.new(-0.5258728625,  1.3782633069, 1.3495508831),
    Circle.new(-0.1403562064,  0.2437382535, 1.3804956588),
    Circle.new( 0.8055826339, -0.0482092025, 0.3327165165),
    Circle.new(-0.6311979224,  0.7184578971, 0.2491045282),
    Circle.new( 1.4685857879, -0.8347049536, 1.3670667538),
    Circle.new(-0.6855727502,  1.6465021616, 1.0593087096),
    Circle.new( 0.0152957411,  0.0638919221, 0.9771215985)
]

var sq = Fn.new { |v| v * v }

var areaScan = Fn.new { |precision|
    var sect = Fn.new { |c, y|
        var dr = (sq.call(c.r) - sq.call(y-c.y)).sqrt
        return Point.new(c.x - dr, c.x + dr)
    }

    var ys = circles.map { |c| c.y + c.r }.toList + circles.map { |c| c.y - c.r }.toList
    var mins = (Nums.min(ys)/precision).floor
    var maxs = (Nums.max(ys)/precision).ceil
    var total = 0
    for (x in mins..maxs) {
        var y = x * precision
        var right = -1/0
        var points = circles.where { |c| (y - c.y).abs < c.r }.map { |c| sect.call(c, y) }.toList
        var cmp = Fn.new { |p1, p2| (p1.x - p2.x).sign }
        Sort.insertion(points, cmp)
        for (p in points) {
            if (p.y > right) {
                total = total + p.y - p.x.max(right)
                right = p.y
            }
        }
    }
    return total * precision
}

var p = 1e-5
System.print("Approximate area = %(areaScan.call(p))")
