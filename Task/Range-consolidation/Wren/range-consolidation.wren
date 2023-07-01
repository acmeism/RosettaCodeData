class Span {
    construct new(r) {
        if (r.type != Range || !r.isInclusive) Fiber.abort("Argument must be an inclusive range.")
        _low = r.from
        _high = r.to
        if (_low > _high) {
            _low = r.to
            _high = r.from
        }
    }

    low  { _low }
    high { _high }

    consolidate(r) {
         if (r.type != Span) Fiber.abort("Argument must be a Span.")
         if (_high < r.low) return [this, r]
         if (r.high < _low) return [r, this]
         return [Span.new(_low.min(r.low).._high.max(r.high))]
    }

    toString { "[%(_low), %(_high)]" }
}

var spanLists = [
    [Span.new(1.1..2.2)],
    [Span.new(6.1..7.2), Span.new(7.2..8.3)],
    [Span.new(4..3), Span.new(2..1)],
    [Span.new(4..3), Span.new(2..1), Span.new(-1..-2), Span.new(3.9..10)],
    [Span.new(1..3), Span.new(-6..-1), Span.new(-4..-5), Span.new(8..2), Span.new(-6..-6)]
]

for (spanList in spanLists) {
    if (spanList.count == 1) {
        System.print(spanList.toString[1..-2])
    } else if (spanList.count == 2) {
        System.print(spanList[0].consolidate(spanList[1]).toString[1..-2])
    } else {
        var first = 0
        while (first < spanList.count-1) {
            var next = first + 1
            while (next < spanList.count) {
                var res = spanList[first].consolidate(spanList[next])
                spanList[first] = res[0]
                if (res.count == 2) {
                    spanList[next] = res[1]
                    next = next + 1
                } else {
                    spanList.removeAt(next)
                }
            }
            first = first + 1
        }
        System.print(spanList.toString[1..-2])
    }
}
