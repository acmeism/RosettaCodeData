# -*- coding: utf-8 -*-

from typing import List, Tuple, Dict, Set
from itertools import cycle, islice
from collections import Counter
import re
import random
import urllib

dict_fname = 'unixdict.txt'
dict_url1 = 'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'    # ~25K words
dict_url2 = 'https://raw.githubusercontent.com/dwyl/english-words/master/words.txt'  # ~470K words

word_regexp = re.compile(r'^[a-z]{3,}$')    # reduce dict words to those of three or more a-z characters.


def load_dictionary(fname: str=dict_fname) -> Set[str]:
    "Return appropriate words from a dictionary file"
    with open(fname) as f:
        return {lcase for lcase in (word.strip().lower() for word in f)
                if word_regexp.match(lcase)}

def load_web_dictionary(url: str) -> Set[str]:
    "Return appropriate words from a dictionary web page"
    words = urllib.request.urlopen(url).read().decode().strip().lower().split()
    return {word for word in words if word_regexp.match(word)}


def get_players() -> List[str]:
    "Return inputted ordered list of contestant names."
    names = input('Space separated list of contestants: ')
    return [n.capitalize() for n in names.strip().split()]

def is_wordiff(wordiffs: List[str], word: str, dic: Set[str], comment=True) -> bool:
    "Is word a valid wordiff from wordiffs[-1] ?"
    if word not in dic:
        if comment:
            print('That word is not in my dictionary')
        return False
    if word in wordiffs:
        if comment:
            print('That word was already used.')
        return False
    if len(word) < len(wordiffs[-1]):
        return is_wordiff_removal(word, wordiffs[-1], comment)
    elif len(word) > len(wordiffs[-1]):
        return is_wordiff_insertion(word, wordiffs[-1], comment)

    return is_wordiff_change(word, wordiffs[-1], comment)


def is_wordiff_removal(word: str, prev: str, comment=True) -> bool:
    "Is word derived from prev by removing one letter?"
    ...
    ans = word in {prev[:i] + prev[i+1:] for i in range(len(prev))}
    if not ans:
        if comment:
            print('Word is not derived from previous by removal of one letter.')
    return ans


def is_wordiff_insertion(word: str, prev: str, comment=True) -> bool:
    "Is word derived from prev by adding one letter?"
    diff = Counter(word) - Counter(prev)
    diffcount = sum(diff.values())
    if diffcount != 1:
        if comment:
            print('More than one character insertion difference.')
        return False

    insert = list(diff.keys())[0]
    ans =  word in {prev[:i] + insert + prev[i:] for i in range(len(prev) + 1)}
    if not ans:
        if comment:
            print('Word is not derived from previous by insertion of one letter.')
    return ans


def is_wordiff_change(word: str, prev: str, comment=True) -> bool:
    "Is word derived from prev by changing exactly one letter?"
    ...
    diffcount = sum(w != p for w, p in zip(word, prev))
    if diffcount != 1:
        if comment:
            print('More or less than exactly one character changed.')
        return False
    return True

def could_have_got(wordiffs: List[str], dic: Set[str]):
    return (word for word in (dic - set(wordiffs))
            if is_wordiff(wordiffs, word, dic, comment=False))

if __name__ == '__main__':
    dic = load_web_dictionary(dict_url2)
    dic_3_4 = [word for word in dic if len(word) in {3, 4}]
    start = random.choice(dic_3_4)
    wordiffs = [start]
    players = get_players()
    for name in cycle(players):
        word = input(f"{name}: Input a wordiff from {wordiffs[-1]!r}: ").strip()
        if is_wordiff(wordiffs, word, dic):
            wordiffs.append(word)
        else:
            print(f'YOU HAVE LOST {name}!')
            print("Could have used:",
                  ', '.join(islice(could_have_got(wordiffs, dic), 10)), '...')
            break
