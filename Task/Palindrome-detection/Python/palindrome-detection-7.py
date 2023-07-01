'''Palindrome detection'''


# isPalindrome :: String -> Bool
def isPalindrome(s):
    '''True if the string is unchanged under reversal.
       (The left half is a reflection of the right half)
    '''
    d, m = divmod(len(s), 2)
    return s[0:d] == s[d + m:][::-1]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''

    print('\n'.join(
        f'{repr(s)} -> {isPalindrome(cleaned(s))}' for s in [
            "",
            "a",
            "ab",
            "aba",
            "abba",
            "In girum imus nocte et consumimur igni"
        ]
    ))


# cleaned :: String -> String
def cleaned(s):
    '''A lower-case copy of s, with spaces pruned.'''
    return [c.lower() for c in s if ' ' != c]


# MAIN ---
if __name__ == '__main__':
    main()
