[10, 5, 2].each { h ->
    def tEuler = tEulerH.rcurry(h)
    assert tEuler.maximumNumberOfParameters == 2
    println """
STEP SIZE == ${h}
  time   analytic   euler   relative
(seconds)  (°C)     (°C)     error
-------- -------- -------- ---------"""
    tEuler(0, 100).each { BigDecimal s, tE ->
        def tA = tAnalytic(s)
        def relError = ((tE - tA)/(tA - 20)).abs()
        printf('%5.0f    %8.4f %8.4f %9.6f\n', s, tA, tE, relError)
    }
}
