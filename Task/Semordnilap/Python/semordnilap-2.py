import os
import random
# Load file and put it to dictionary as set
dictionary = {word.rstrip(os.linesep) for word in open('unixdict.txt')}

# List of results
results = []
for word in dictionary:
    # [::-1] reverses string
    reversed_word = word[::-1]
    if reversed_word in dictionary and word > reversed_word:
        results.append((word, reversed_word))

print(len(results))
for words in random.sample(results, 5):
    print(' '.join(words))
