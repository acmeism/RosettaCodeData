def ownCalcPass (password, nonce, test=False) :
    start = True
    num1 = 0
    num2 = 0
    password = int(password)
    if test:
        print("password: %08x" % (password))
    for c in nonce :
        if c != "0":
            if start:
                num2 = password
            start = False
        if test:
            print("c: %s num1: %08x num2: %08x" % (c, num1, num2))
        if c == '1':
            num1 = (num2 & 0xFFFFFF80) >> 7
            num2 = num2 << 25
        elif c == '2':
            num1 = (num2 & 0xFFFFFFF0) >> 4
            num2 = num2 << 28
        elif c == '3':
            num1 = (num2 & 0xFFFFFFF8) >> 3
            num2 = num2 << 29
        elif c == '4':
            num1 = num2 << 1
            num2 = num2 >> 31
        elif c == '5':
            num1 = num2 << 5
            num2 = num2 >> 27
        elif c == '6':
            num1 = num2 << 12
            num2 = num2 >> 20
        elif c == '7':
            num1 = num2 & 0x0000FF00 | (( num2 & 0x000000FF ) << 24 ) | (( num2 & 0x00FF0000 ) >> 16 )
            num2 = ( num2 & 0xFF000000 ) >> 8
        elif c == '8':
            num1 = (num2 & 0x0000FFFF) << 16 | ( num2 >> 24 )
            num2 = (num2 & 0x00FF0000) >> 8
        elif c == '9':
            num1 = ~num2
        else :
            num1 = num2

        num1 &= 0xFFFFFFFF
        num2 &= 0xFFFFFFFF
        if (c not in "09"):
            num1 |= num2
        if test:
            print("     num1: %08x num2: %08x" % (num1, num2))
        num2 = num1
    return num1

def test_passwd_calc(passwd, nonce, expected):
    res = ownCalcPass(passwd, nonce, False)
    m = passwd+' '+nonce+' '+str(res)+' '+str(expected)
    if res == int(expected) :
        print('PASS '+m)
    else :
        print('FAIL '+m)

if __name__ == '__main__':
    test_passwd_calc('12345','603356072','25280520')
    test_passwd_calc('12345','410501656','119537670')
    test_passwd_calc('12345','630292165','4269684735')
