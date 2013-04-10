def eqindex2Pass(data):
    "Two pass"
    suml, sumr, ddelayed = 0, sum(data), 0
    for i, d in enumerate(data):
        suml += ddelayed
        sumr -= d
        ddelayed = d
        if suml == sumr:
            yield i
