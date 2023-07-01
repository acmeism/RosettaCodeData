def assertBounds = { List bounds, int nRect ->
    assert (bounds.size() == 2) && (bounds[0] instanceof Double) && (bounds[1] instanceof Double) && (nRect > 0)
}

def integral = { List bounds, int nRectangles, Closure f, List pointGuide, Closure integralCalculator->
    double a = bounds[0], b = bounds[1], h = (b - a)/nRectangles
    def xPoints = pointGuide.collect { double it -> a + it*h }
    def fPoints = xPoints.collect { x -> f(x) }
    integralCalculator(h, fPoints)
}

def leftRectIntegral = { List bounds, int nRect, Closure f ->
    assertBounds(bounds, nRect)
    integral(bounds, nRect, f, (0..<nRect)) { h, fPoints -> h*fPoints.sum() }
}

def rightRectIntegral = { List bounds, int nRect, Closure f ->
    assertBounds(bounds, nRect)
    integral(bounds, nRect, f, (1..nRect)) { h, fPoints -> h*fPoints.sum() }
}

def midRectIntegral = { List bounds, int nRect, Closure f ->
    assertBounds(bounds, nRect)
    integral(bounds, nRect, f, ((0.5d)..nRect)) { h, fPoints -> h*fPoints.sum() }
}

def trapezoidIntegral = { List bounds, int nRect, Closure f ->
    assertBounds(bounds, nRect)
    integral(bounds, nRect, f, (0..nRect)) { h, fPoints ->
        def fLeft  = fPoints[0..<nRect]
        def fRight = fPoints[1..nRect]
        h/2*(fLeft + fRight).sum()
    }
}

def simpsonsIntegral = { List bounds, int nSimpRect, Closure f ->
    assertBounds(bounds, nSimpRect)
    integral(bounds, nSimpRect*2, f, (0..(nSimpRect*2))) { h, fPoints ->
        def fLeft  = fPoints[(0..<nSimpRect*2).step(2)]
        def fMid   = fPoints[(1..<nSimpRect*2).step(2)]
        def fRight = fPoints[(2..nSimpRect*2).step(2)]
        h/3*((fLeft + fRight).sum() + 4*(fMid.sum()))
    }
}
