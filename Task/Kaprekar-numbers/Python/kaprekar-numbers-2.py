def encode(n, base):
    result = ""
    while n:
        n, d = divmod(n, base)
        if d < 10:
            result += str(d)
        else:
            result += chr(d - 10 + ord("a"))
    return result[::-1]
def Kaprekar(n, base):
    if n == '1':
        return True
    sq = encode((int(n, base)**2), base)
    for i in range(1,len(sq)):
        if (int(sq[:i], base) + int(sq[i:], base) == int(n, base)) and (int(sq[:i], base) > 0) and (int(sq[i:], base)>0):
            return True
    return False
def Find(m, n, base):
    return [encode(i, base) for i in range(m,n+1) if Kaprekar(encode(i, base), base)]

m = int(raw_input('Where to start?\n'))
n = int(raw_input('Where to stop?\n'))
base = int(raw_input('Enter base:'))
KNumbers = Find(m, n, base)
for i in KNumbers:
    print i
print 'The number of Kaprekar Numbers found are',
print len(KNumbers)
raw_input()
