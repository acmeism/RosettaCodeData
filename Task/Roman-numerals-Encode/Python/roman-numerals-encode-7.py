rnl = [ { '4' : 'MMMM', '3' : 'MMM', '2' : 'MM', '1' : 'M', '0' : '' }, { '9' : 'CM', '8' : 'DCCC', '7' : 'DCC',
          '6' : 'DC', '5' : 'D', '4' : 'CD', '3' : 'CCC', '2' : 'CC', '1' : 'C', '0' : '' }, { '9' : 'XC',
          '8' : 'LXXX', '7' : 'LXX', '6' : 'LX', '5' : 'L', '4' : 'XL', '3' : 'XXX', '2' : 'XX', '1' : 'X',
          '0' : '' }, { '9' : 'IX', '8' : 'VIII', '7' : 'VII', '6' : 'VI', '5' : 'V', '4' : 'IV', '3' : 'III',
          '2' : 'II', '1' : 'I', '0' : '' }]
# Option 1
def number2romannumeral(n):
    return ''.join([rnl[x][y] for x, y in zip(range(4), str(n).zfill(4)) if n < 5000 and n > -1])
# Option 2
def number2romannumeral(n):
    return reduce(lambda x, y: x + y, map(lambda x, y: rnl[x][y], range(4), str(n).zfill(4))) if -1 < n < 5000 else None
