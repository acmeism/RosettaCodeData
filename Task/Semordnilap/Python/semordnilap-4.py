import sys
import random
import requests

URL = 'http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'


def find_semordnilaps():
  """
  This generator could just take the `word_generator`
  as an argument and read words from it. That would
  have been both simpler and more efficient, but it
  is implemented this way for the sake of illustration.
  """
  seen = set()
  word = None

  while True:
    word = yield word

    if word not in seen:
      seen.add(word[::-1])
      word = None


def semordnilap_words(word_generator):

  semordnilaps_finder = find_semordnilaps()
  semordnilaps_finder.send(None)

  words = map(semordnilaps_finder.send, word_generator)

  # need to get rid of `None` values for words which are not semordnilaps
  yield from filter(None, words)


def url_lines(url):
  with requests.get(url, stream=True) as req:
    yield from req.iter_lines(decode_unicode=True)


def main(url=URL, num_of_examples=5):

  semordnilaps_generator = semordnilap_words(url_lines(url))

  semordnilaps = list(semordnilaps_generator)

  example_words = random.choices(semordnilaps, k=num_of_examples)
  example_pairs = ((word, word[::-1]) for word in example_words)

  print(('found %(num)s semordnilap usernames:\n'
         '%(examples)s\n'
         '...'
        ) % dict(
          num = len(semordnilaps),
          examples = '\n'.join(str(pair) for pair in example_pairs),
        ))

  return semordnilaps


if __name__ == '__main__':
  main(*sys.argv[1:])
