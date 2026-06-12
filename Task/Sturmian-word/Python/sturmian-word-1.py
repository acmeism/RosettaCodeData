def sturmian_word(m, n):
    sturmian = ""
    def invert(string):
      return ''.join(list(map(lambda b: {"0":"1", "1":"0"}[b], string)))
    if m > n:
      return invert(sturmian_word(n, m))

    k = 1
    while True:
        current_floor = int(k * m / n)
        previous_floor = int((k - 1) * m / n)
        if k * m % n == 0:
            break
        if previous_floor == current_floor:
            sturmian += "0"
        else:
            sturmian += "10"
        k += 1
    return sturmian

