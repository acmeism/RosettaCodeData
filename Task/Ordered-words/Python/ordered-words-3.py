'''The longest ordered words in a list'''

from functools import reduce
from operator import le
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
            ordered(w)
        ) else nxs
    ) if lng >= n else nxs


# ordered :: String -> Bool
def ordered(w):
    '''True if the word w is ordered.'''
    return all(map(le, w, w[1:]))


# ------------------------- TEST -------------------------
if __name__ == '__main__':
    print(
        '\n'.join(longestOrds(
            urllib.request.urlopen(
                'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'
            ).read().decode("utf-8").split()
        ))
    )
