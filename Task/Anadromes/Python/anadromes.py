# anadrome.py by Xing216
with open("words.txt","r") as f:
    words = f.read().splitlines()
word_set = set(words)
seen_words = []
word_list = []
for word in word_set:
    if len(word) > 6:
        reversed_word = word[::-1]
        if reversed_word in word_set and reversed_word != word \
           and (reversed_word,word) not in seen_words:
            word_list.append((word, reversed_word))
            seen_words.append((word,reversed_word))
for word,reversed_word in sorted(word_list, key=lambda x: x[0]):
    print(f"{word:>9} {reversed_word}")
