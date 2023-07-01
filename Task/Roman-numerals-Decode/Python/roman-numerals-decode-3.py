numerals = { 'M' : 1000, 'D' : 500, 'C' : 100, 'L' : 50, 'X' : 10, 'V' : 5, 'I' : 1 }
def romannumeral2number(s):
        return reduce(lambda x, y: -x + y if x < y else x + y, map(lambda x: numerals.get(x, 0), s.upper()))
