##
function issqr(n: integer) := n.Sqrt.Floor.sqr = n;

var alltriples := (1..13).Cartesian(3).Where(x -> (x[0] <= x[1]) and (x[1] <= x[2]));

var tri90 := alltriples.where(x -> x[0].sqr + x[1].sqr = x[2].sqr);
println('For an angle of 90 there are', tri90.count, 'solutions:');
tri90.println;

var tri60 := alltriples.Where(x -> (x[0].sqr + x[1].sqr - x[0] * x[1] = x[2].sqr) or
                                   (x[0].sqr + x[2].sqr - x[0] * x[2] = x[1].sqr));
println(#10, 'For an angle of 60 there are', tri60.count, 'solutions:');
tri60.println;

var tri120 := alltriples.Where(x -> x[0].sqr + x[1].sqr + x[0] * x[1] = x[2].sqr);
println(#10, 'For an angle of 120 there are', tri120.count, 'solutions:');
tri120.println;

var tri60notsame := (1..10_000)
                    .Combinations(2)
                    .Where(x -> issqr(x[0].sqr + x[1].sqr - x[0] * x[1]))
                    .Count;
println(#10, '60 degree triangle where sides are not equal, there are', tri60notsame, 'solutions');
