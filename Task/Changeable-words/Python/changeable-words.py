from collections import defaultdict, Counter


def getwords(minlength=11, fname='unixdict.txt'):
    "Return set of lowercased words of > given number of characters"
    with open(fname) as f:
        words = f.read().strip().lower().split()
    return {w for w in words if len(w) > minlength}

words11 = getwords()
word_minus_1 = defaultdict(list)    # map word minus char to (word, index) pairs
minus_1_to_word = defaultdict(list) # map word minus char to word

for w in words11:
    for i in range(len(w)):
        minus_1 = w[:i] + w[i+1:]
        word_minus_1[minus_1].append((w, i))   # minus one char
        if minus_1 in words11:
            minus_1_to_word[minus_1].append(w)

cwords = set()  # Changed char words
for _, v in word_minus_1.items():
    if len(v) >1:
        change_indices = Counter(i for wrd, i in v)
        change_words = set(wrd for wrd, i in v)
        words_changed = None
        if len(change_words) > 1 and change_indices.most_common(1)[0][1] > 1:
            words_changed = [wrd for wrd, i in v
                             if change_indices[i] > 1]
        if words_changed:
            cwords.add(tuple(sorted(words_changed)))

print(f"{len(minus_1_to_word)} words that are from deleting a char from other words:")
for k, v in sorted(minus_1_to_word.items()):
    print(f"  {k:12} From {', '.join(v)}")

print(f"\n{len(cwords)} words that are from changing a char from other words:")
for v in sorted(cwords):
    print(f"  {v[0]:12} From {', '.join(v[1:])}")
