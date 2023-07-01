def eqindexMultiPass(data):
    "Multi pass"
    for i in range(len(data)):
        suml, sumr = sum(data[:i]), sum(data[i+1:])
        if suml == sumr:
            yield i
