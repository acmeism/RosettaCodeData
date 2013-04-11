def eulerStep = { xn, yn, h, dydx ->
    (yn + h * dydx(xn, yn)) as BigDecimal
}

Map eulerMapping = { x0, y0, h, dydx, stopCond = { xx, yy, hh, xx0 -> abs(xx - xx0) > (hh * 100)  }.rcurry(h, x0) ->
    Map yMap = [:]
    yMap[x0] = y0 as BigDecimal
    def x = x0
    while (!stopCond(x, yMap[x])) {
        yMap[x + h] = eulerStep(x, yMap[x], h, dydx)
        x += h
    }
    yMap
}
assert eulerMapping.maximumNumberOfParameters == 5
