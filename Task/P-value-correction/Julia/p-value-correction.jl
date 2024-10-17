using MultipleTesting, IterTools, Printf

p = [4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
     8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
     4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
     8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
     3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
     1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
     4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
     3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
     1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
     2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03]

function printpvalues(v)
    for chunk in partition(v, 10)
        println(join((@sprintf("%4.7f", p) for p in chunk), ", "))
    end
end

println("Original p-values:")
printpvalues(p)
for corr in (Bonferroni(), BenjaminiHochberg(), BenjaminiYekutieli(), Holm(), Hochberg(), Hommel())
    println("\n", corr)
    printpvalues(adjust(p, corr))
end
