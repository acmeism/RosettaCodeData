from collections import Counter

with open("unixdict.txt", "r") as fd:
    for line in fd:
        word = line.strip()
        if len(word) < 11:
            continue

        vowels = Counter(ch for ch in word if ch in "aeiou")
        if len(vowels) == 5 and sum(vowels.values()) == 5:
            print(word)
