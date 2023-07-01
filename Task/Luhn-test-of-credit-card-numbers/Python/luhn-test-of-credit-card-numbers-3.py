'''Luhn test of credit card numbers'''

from itertools import cycle


# luhn :: String -> Bool
def luhn(k):
    '''True if k is a valid Luhn credit card number string
    '''
    def asDigits(s):
        return (int(c) for c in s)

    return 0 == sum(map(
        lambda f, x: f(x),
        cycle([
            lambda n: n,
            lambda n: sum(asDigits(str(2 * n)))
        ]),
        asDigits(reversed(k))
    )) % 10


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Tests'''
    print('\n'.join([
        repr((x, luhn(x))) for x in [
            "49927398716",
            "49927398717",
            "1234567812345678",
            "1234567812345670"
        ]
    ]))


if __name__ == '__main__':
    main()
