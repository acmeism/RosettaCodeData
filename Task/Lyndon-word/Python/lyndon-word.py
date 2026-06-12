def next_word(n, w, alphabet):
    x = (w * ((n // len(w)) + 1))[:n]
    while x and x[-1] == alphabet[-1]:
        x = x[:-1]
    if x:
        last_char = x[-1]
        next_char_index = alphabet.index(last_char) + 1
        x = x[:-1] + alphabet[next_char_index]
    return x

def generate_lyndon_words(n, alphabet):
    w = alphabet[0]
    while len(w) <= n:
        yield w
        w = next_word(n, w, alphabet)
        if not w: break

lyndon_words = generate_lyndon_words(5, [str(i) for i in range(2)])
for word in lyndon_words:
    print(word)
