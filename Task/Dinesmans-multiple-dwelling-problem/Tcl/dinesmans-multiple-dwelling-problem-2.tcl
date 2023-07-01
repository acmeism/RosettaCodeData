set soln [dinesmanSolve {1 2 3 4 5} {Baker Cooper Fletcher Miller Smith} {
    {$Baker != 5}
    {$Cooper != 1}
    {$Fletcher != 1 && $Fletcher != 5}
    {$Miller > $Cooper}
    {abs($Smith-$Fletcher) != 1}
    {abs($Fletcher-$Cooper) != 1}
}]
puts "Solution found:"
foreach {where who} $soln {puts "   Floor ${where}: $who"}
