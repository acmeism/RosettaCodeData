from random import SystemRandom

# Initialise a cryptographically secure RNG backed by OS-level entropy
# (e.g., /dev/urandom on Unix, BCryptGenRandom on Windows)
rnd = SystemRandom()

def passphrase(wl: list[str], n: int = 5) -> str:
    """
    Generate a secure, human-readable passphrase.

    Args:
        wl: A list of candidate words.
        n: Number of word-number pairs to include (default: 5).

    Returns:
        A hyphen-separated string of title-cased words, each appended
        with a random integer between 0 and 99.
    """
    return "-".join(f"{rnd.choice(wl).title()}{rnd.randint(0, 99)}" for _ in range(n))

if __name__ == "__main__":
    # Load the standard Unix dictionary file
    file = open("/usr/share/dict/words", "r")
    # Filter out possessives ('s) and words ≤ 2 characters long
    wordList = list(filter(
        lambda word: not word.endswith("'s") and len(word) > 2,
        file.read().strip().split("\n")
    ))
    file.close()

    # Print a single sample passphrase (uses default n=5)
    print(
        "Sample:\n"
        f"{passphrase(wordList)}"
        "\n"
    )
    # Print batched examples to visually demonstrate entropy scaling with length
    print(
        "Stretch:\n"
        "  5 words:\n"
        f"    {"\n    ".join(passphrase(wordList) for _ in range(10))}\n"
        "\n"
        "  8 words:\n"
        f"    {"\n    ".join(passphrase(wordList, 8) for _ in range(10))}\n"
        "\n"
        "  12 words:\n"
        f"    {"\n    ".join(passphrase(wordList, 12) for _ in range(10))}\n"
    )
