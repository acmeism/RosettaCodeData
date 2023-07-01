def tol = 0.000000001  // tolerance: acceptable "wrongness" to account for rounding error

((1..6) + [16]). each { n ->
    println "rootsOfUnity(${n}):"
    def rou = rootsOfUnity(n)
    rou.each { println it }
    assert rou[0] == 1
    def actual = n > 1 ? rou[Math.floor(n/2) as int] : rou[0]
    def expected = n > 1 ? (n%2 == 0) ? -1 : ~rou[Math.ceil(n/2) as int] : rou[0]
    def message = n > 1 ? (n%2 == 0) ? 'middle-most root should be -1' : 'two middle-most roots should be conjugates' : ''
    assert (actual - expected).abs() < tol : message
    assert rou.every { (it.rho - 1) < tol } : 'all roots should have magnitude 1'
    println()
}
