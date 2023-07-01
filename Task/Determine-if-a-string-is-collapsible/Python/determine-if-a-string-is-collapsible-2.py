'''Determining if a string is collapsible'''

from operator import eq


# isCollapsible :: String -> Bool
def isCollapsible(s):
    '''True if s contains any consecutively
       repeated characters.
    '''
    return False if 2 > len(s) else (
        any(map(eq, s, s[1:]))
    )


# ------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Determining whether each string is collapsible'''
    xs = [
        "",
        '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌",
        "abcdefghijklmnopqrstuvwxyz"
    ]
    print([
        isCollapsible(x) for x in xs
    ])


# MAIN ---
if __name__ == '__main__':
    main()
