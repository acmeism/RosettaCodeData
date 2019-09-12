'''The longest ordered words in a list'''

from functools import reduce
import urllib.request


# longestOrds :: [String] -> [String]
def longestOrds(ws):
    '''The longest ordered words in a given list.
    '''
    return reduce(triage, ws, (0, []))[1]


# triage :: (Int, [String]) -> String -> (Int, [String])
def triage(nxs, w):
    '''The maximum length seen for an ordered word,
       and the ordered words of this length seen so far.
    '''
    n, xs = nxs
    lng = len(w)
    return (
        (lng, ([w] if n != lng else xs + [w])) if (
            ordWord(w)
        ) else nxs
    ) if lng >= n else nxs


# ordWord :: String -> Bool
def ordWord(w):
    '''True if the word w is ordered.'''
    return reduce(stillRising, w[1:], (True, w[0]))[0]


# stillRising :: (Bool, Char) -> Char -> (Bool, Char)
def stillRising(bc, x):
    '''A boolean value paired with the current character.
       The boolean is true if no character in the word
       so far has been alphabetically lower than its
       predecessor.
    '''
    b, c = bc
    return ((x >= c) if b else b, x)


# TEST ---
if __name__ == '__main__':
    print(
        '\n'.join(longestOrds(
            urllib.request.urlopen(
                'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'
            ).read().decode("utf-8").split()
        ))
    )
