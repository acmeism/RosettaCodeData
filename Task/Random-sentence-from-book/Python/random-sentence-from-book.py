from urllib.request import urlopen
import re
from string import punctuation
from collections import Counter, defaultdict
import random


# The War of the Worlds, by H. G. Wells
text_url = 'http://www.gutenberg.org/files/36/36-0.txt'
text_start = 'No one would have believed'

sentence_ending = '.!?'
sentence_pausing = ',;:'

def read_book(text_url, text_start) -> str:
    with urlopen(text_url) as book:
        text = book.read().decode('utf-8')
    return text[text.index(text_start):]

def remove_punctuation(text: str, keep=sentence_ending+sentence_pausing)-> str:
    "Remove punctuation, keeping some"
    to_remove = ''.join(set(punctuation) - set(keep))
    text = text.translate(str.maketrans(to_remove, ' ' * len(to_remove))).strip()
    text = re.sub(fr"[^a-zA-Z0-9{keep}\n ]+", ' ', text)
    # Remove duplicates and put space around remaining punctuation
    if keep:
        text = re.sub(f"([{keep}])+", r" \1 ", text).strip()
    if text[-1] not in sentence_ending:
        text += ' .'
    return text.lower()

def word_follows_words(txt_with_pauses_and_endings):
    "return dict of freq of words following one/two words"
    words = ['.'] + txt_with_pauses_and_endings.strip().split()

    # count of what word follows this
    word2next = defaultdict(lambda :defaultdict(int))
    word2next2 = defaultdict(lambda :defaultdict(int))
    for lh, rh in zip(words, words[1:]):
        word2next[lh][rh] += 1
    for lh, mid, rh in zip(words, words[1:], words[2:]):
        word2next2[(lh, mid)][rh] += 1

    return dict(word2next), dict(word2next2)

def gen_sentence(word2next, word2next2) -> str:

    s = ['.']
    s += random.choices(*zip(*word2next[s[-1]].items()))
    while True:
        s += random.choices(*zip(*word2next2[(s[-2], s[-1])].items()))
        if s[-1] in sentence_ending:
            break

    s  = ' '.join(s[1:]).capitalize()
    s = re.sub(fr" ([{sentence_ending+sentence_pausing}])", r'\1', s)
    s = re.sub(r" re\b", "'re", s)
    s = re.sub(r" s\b", "'s", s)
    s = re.sub(r"\bi\b", "I", s)

    return s

if __name__ == "__main__":
    txt_with_pauses_and_endings = remove_punctuation(read_book(text_url, text_start))
    word2next, word2next2 = word_follows_words(txt_with_pauses_and_endings)
    #%%
    sentence = gen_sentence(word2next, word2next2)
    print(sentence)
