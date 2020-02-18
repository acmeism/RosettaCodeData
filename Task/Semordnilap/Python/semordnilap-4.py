import sys
import random
import requests

URL = 'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'


def find_semordnilaps(word_generator):

  # Keys in this dict are the words seen so far, reversed.
  # Values are booleans determining whether we have seen (and yielded)
  # the key, so that we don't yield the same word twice.
  seen = {}

  for word in word_generator:
    if word not in seen:
      reversed_word = word[::-1]
      seen[reversed_word] = False  # not yielded yet
    else:
      yielded_already = seen[word]
      if not yielded_already:
        yield word
        seen[word] = True  # the word has been yielded


def url_lines(url):
  with requests.get(url, stream=True) as req:
    yield from req.iter_lines(decode_unicode=True)


def main(url=URL, num_of_examples=5):

  semordnilaps_generator = find_semordnilaps(url_lines(url))

  semordnilaps = list(semordnilaps_generator)

  example_words = random.choices(semordnilaps, k=int(num_of_examples))
  example_pairs = ((word, word[::-1]) for word in example_words)

  print(
    f'found {len(semordnilaps)} semordnilap usernames:',
    * ['%s %s' % p for p in example_pairs]+['...'],
    sep='\n'
  )

  return semordnilaps


if __name__ == '__main__':
  main(*sys.argv[1:])
