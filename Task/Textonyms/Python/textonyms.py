from collections import defaultdict
import urllib.request

CH2NUM = {ch: str(num) for num, chars in enumerate('abc def ghi jkl mno pqrs tuv wxyz'.split(), 2) for ch in chars}
URL = 'http://www.puzzlers.org/pub/wordlists/unixdict.txt'


def getwords(url):
 return urllib.request.urlopen(url).read().decode("utf-8").lower().split()

def mapnum2words(words):
    number2words = defaultdict(list)
    reject = 0
    for word in words:
        try:
            number2words[''.join(CH2NUM[ch] for ch in word)].append(word)
        except KeyError:
            # Reject words with non a-z e.g. '10th'
            reject += 1
    return dict(number2words), reject

def interactiveconversions():
    global inp, ch, num
    while True:
        inp = input("\nType a number or a word to get the translation and textonyms: ").strip().lower()
        if inp:
            if all(ch in '23456789' for ch in inp):
                if inp in num2words:
                    print("  Number {0} has the following textonyms in the dictionary: {1}".format(inp, ', '.join(
                        num2words[inp])))
                else:
                    print("  Number {0} has no textonyms in the dictionary.".format(inp))
            elif all(ch in CH2NUM for ch in inp):
                num = ''.join(CH2NUM[ch] for ch in inp)
                print("  Word {0} is{1} in the dictionary and is number {2} with textonyms: {3}".format(
                    inp, ('' if inp in wordset else "n't"), num, ', '.join(num2words[num])))
            else:
                print("  I don't understand %r" % inp)
        else:
            print("Thank you")
            break


if __name__ == '__main__':
    words = getwords(URL)
    print("Read %i words from %r" % (len(words), URL))
    wordset = set(words)
    num2words, reject = mapnum2words(words)
    morethan1word = sum(1 for w in num2words if len(num2words[w]) > 1)
    maxwordpernum = max(len(values) for values in num2words.values())
    print("""
There are {0} words in {1} which can be represented by the Textonyms mapping.
They require {2} digit combinations to represent them.
{3} digit combinations represent Textonyms.\
""".format(len(words) - reject, URL, len(num2words), morethan1word))

    print("\nThe numbers mapping to the most words map to %i words each:" % maxwordpernum)
    maxwpn = sorted((key, val) for key, val in num2words.items() if len(val) == maxwordpernum)
    for num, wrds in maxwpn:
        print("  %s maps to: %s" % (num, ', '.join(wrds)))

    interactiveconversions()
