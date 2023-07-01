# Python3 implementation of Chaocipher
# left wheel = ciphertext wheel
# right wheel = plaintext wheel

def main():
    # letters only! makealpha(key) helps generate lalpha/ralpha.
    lalpha = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    ralpha = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
    msg = "WELLDONEISBETTERTHANWELLSAID"

    print("L:", lalpha)
    print("R:", ralpha)
    print("I:", msg)
    print("O:", do_chao(msg, lalpha, ralpha, 1, 0), "\n")

    do_chao(msg, lalpha, ralpha, 1, 1)

def do_chao(msg, lalpha, ralpha, en=1, show=0):
    msg = correct_case(msg)
    out = ""
    if show:
        print("="*54)
        print(10*" " + "left:" + 21*" " + "right: ")
        print("="*54)
        print(lalpha, ralpha, "\n")
    for L in msg:
        if en:
            lalpha, ralpha = rotate_wheels(lalpha, ralpha, L)
            out += lalpha[0]
        else:
            ralpha, lalpha = rotate_wheels(ralpha, lalpha, L)
            out += ralpha[0]
        lalpha, ralpha = scramble_wheels(lalpha, ralpha)
        if show:
            print(lalpha, ralpha)
    return out

def makealpha(key=""):
    alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    z = set()
    key = [x.upper() for x in (key + alpha[::-1])
           if not (x.upper() in z or z.add(x.upper()))]
    return "".join(key)

def correct_case(string):
    return "".join([s.upper() for s in string if s.isalpha()])

def permu(alp, num):
    alp = alp[:num], alp[num:]
    return "".join(alp[::-1])

def rotate_wheels(lalph, ralph, key):
    newin = ralph.index(key)
    return permu(lalph, newin), permu(ralph, newin)

def scramble_wheels(lalph, ralph):
    # LEFT = cipher wheel
    # Cycle second[1] through nadir[14] forward
    lalph = list(lalph)
    lalph = "".join([*lalph[0],
                    *lalph[2:14],
                    lalph[1],
                    *lalph[14:]])

    # RIGHT = plain wheel
    # Send the zenith[0] character to the end[25],
    # cycle third[2] through nadir[14] characters forward
    ralph = list(ralph)
    ralph = "".join([*ralph[1:3],
                     *ralph[4:15],
                     ralph[3],
                     *ralph[15:],
                     ralph[0]])
    return lalph, ralph

main()
