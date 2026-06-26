from collections.abc import Iterable

def semordnilap(words: Iterable[str]) -> list[tuple[str, str]]:
    words_ = {w: "".join(reversed(w)) for w in words}
    pairs = {(w, r) for w, r in words_.items() if w < r and r in words_}
    return sorted(pairs, key=lambda p: (len(p[0]), p))

if __name__ == "__main__":
    with open("unixdict.txt") as f:
        words = (line.strip() for line in f.readlines())
        semordnilap_words = semordnilap(words)

        print(f"Found {len(semordnilap_words)} semordnilap words:")
        print(semordnilap_words[-5:])
