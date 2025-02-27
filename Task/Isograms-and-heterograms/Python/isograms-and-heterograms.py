from collections import Counter

def find_n_isograms(wordlist):
    n_isograms = []
    for word in wordlist:
        word_lower = word.lower()
        freq = Counter(word_lower)
        frequencies = freq.values()
        if len(set(frequencies)) == 1 and next(iter(frequencies)) > 1:
            n = next(iter(frequencies))
            n_isograms.append((-n, -len(word), word))
    n_isograms.sort()
    return [word for _, _, word in n_isograms]

def find_heterograms(wordlist):
    heterograms = []
    for word in wordlist:
        if len(word) > 10:
            word_lower = word.lower()
            if len(set(word_lower)) == len(word_lower):
                heterograms.append((-len(word), word))
    heterograms.sort()
    return [word for _, word in heterograms]

with open('unidict.txt', 'r') as file:
    wordlist = [line.strip() for line in file]

n_isograms_result = find_n_isograms(wordlist)
heterograms_result = find_heterograms(wordlist)

print("n-isograms (n > 1):", n_isograms_result)
print("Heterograms with more than 10 characters:", heterograms_result)
