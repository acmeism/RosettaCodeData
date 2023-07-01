>>> oct2bin = {'0': '000', '1': '001', '2': '010', '3': '011', '4': '100', '5': '101', '6': '110', '7': '111'}
>>> bin = lambda n: ''.join(oct2bin[octdigit] for octdigit in '%o' % n).lstrip('0') or '0'
>>> for i in range(16): print(bin(i))

0
1
10
11
100
101
110
111
1000
1001
1010
1011
1100
1101
1110
1111
