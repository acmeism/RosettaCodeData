#!/usr/bin/env python3

def redact(source, word, partial=False, insensitive=False, overkill=False):
    def different(s, w):
        if insensitive:
            return s.upper() != w.upper()
        else:
            return s != w

    def is_word_char(c):
        return c == '-' or c.isalpha()

    temp = list(source)
    i = 0
    while i <= len(temp) - len(word):
        match = True
        j = 0
        while j < len(word):
            if different(temp[i + j], word[j]):
                match = False
                break
            j += 1
        if match:
            beg = i
            end = i + len(word)
            if not partial:
                if beg > 0 and is_word_char(temp[beg - 1]):
                    i += 1
                    continue
                if end < len(temp) and is_word_char(temp[end]):
                    i += 1
                    continue
            if overkill:
                while beg > 0 and is_word_char(temp[beg - 1]):
                    beg -= 1
                while end < len(temp) - 1 and is_word_char(temp[end]):
                    end += 1
            for k in range(beg, end):
                temp[k] = 'X'
        i += 1
    return ''.join(temp)

def example(source, word):
    print("Redact '", word, "':")
    print("[w|s|n]", redact(source, word, False, False, False))
    print("[w|i|n]", redact(source, word, False, True, False))
    print("[p|s|n]", redact(source, word, True, False, False))
    print("[p|i|n]", redact(source, word, True, True, False))
    print("[p|s|o]", redact(source, word, True, False, True))
    print("[p|i|o]", redact(source, word, True, True, True))
    print()

if __name__ == "__main__":
    text = 'Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That\'s so tom'
    example(text, "Tom")
    example(text, "tom")
