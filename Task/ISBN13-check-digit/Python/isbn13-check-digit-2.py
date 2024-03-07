'''ISBN13 check digit'''


from itertools import cycle


# isISBN13 :: String -> Bool
def isISBN13(s):
    '''True if s is a valid ISBN13 string
    '''
    digits = [int(c) for c in s if c.isdigit()]
    return 13 == len(digits) and (
        0 == sum(map(
            lambda f, x: f(x),
            cycle([
                lambda x: x,
                lambda x: 3 * x
            ]),
            digits
        )) % 10
    )


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test strings for ISBN-13 validity.'''

    print('\n'.join(
        repr((s, isISBN13(s))) for s
        in ["978-0596528126",
            "978-0596528120",
            "978-1788399081",
            "978-1788399083"
            ]
    ))


# MAIN ---
if __name__ == '__main__':
    main()
