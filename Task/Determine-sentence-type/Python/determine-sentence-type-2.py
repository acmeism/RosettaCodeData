'''Grouping and tagging by final character of string'''

from functools import reduce
from itertools import groupby


# tagGroups :: Dict -> [String] -> [(String, [String])]
def tagGroups(tagDict):
    '''A list of (Tag, SentenceList) tuples, derived
       from an input text and a supplied dictionary of
       tags for each of a set of final punctuation marks.
    '''
    def go(sentences):
        return [
            (tagDict.get(k, 'Not punctuated'), list(v))
            for (k, v) in groupby(
                sorted(sentences, key=last),
                key=last
            )
        ]
    return go


# sentenceSegments :: Chars -> String -> [String]
def sentenceSegments(punctuationChars):
    '''A list of sentences delimited by the supplied
       punctuation characters, where these are followed
       by spaces.
    '''
    def go(s):
        return [
            ''.join(cs).strip() for cs
            in splitBy(
                sentenceBreak(punctuationChars)
            )(s)
        ]
    return go


# sentenceBreak :: Chars -> (Char, Char) -> Bool
def sentenceBreak(finalPunctuation):
    '''True if the first of two characters is a final
       punctuation mark and the second is a space.
    '''
    def go(a, b):
        return a in finalPunctuation and " " == b
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Join, segmentation, tags'''

    tags = {'!': 'E', '?': 'Q', '.': 'S'}

    # Joined by spaces,
    sample = ' '.join([
        "Hi there, how are you today?",
        "I'd like to present to you the washing machine 9001.",
        "You have been nominated to win one of these!",
        "Might it be possible to add some challenge to this task?",
        "Feels as light as polystyrene filler.",
        "But perhaps substance isn't the goal!",
        "Just make sure you don't break off before the"
    ])

    # segmented by punctuation,
    sentences = sentenceSegments(
        tags.keys()
    )(sample)

    # and grouped under tags.
    for kv in tagGroups(tags)(sentences):
        print(kv)


# ----------------------- GENERIC ------------------------

# last :: [a] -> a
def last(xs):
    '''The last element of a non-empty list.'''
    return xs[-1]


# splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
def splitBy(p):
    '''A list split wherever two consecutive
       items match the binary predicate p.
    '''
    # step :: ([[a]], [a], a) -> a -> ([[a]], [a], a)
    def step(acp, x):
        acc, active, prev = acp

        return (acc + [active], [x], x) if p(prev, x) else (
            (acc, active + [x], x)
        )

    # go :: [a] -> [[a]]
    def go(xs):
        if 2 > len(xs):
            return xs
        else:
            h = xs[0]
            ys = reduce(step, xs[1:], ([], [h], h))
            # The accumulated sublists, and the final group.
            return ys[0] + [ys[1]]

    return go


# MAIN ---
if __name__ == '__main__':
    main()
