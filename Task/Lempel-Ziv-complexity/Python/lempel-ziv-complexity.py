def lempelZivComplexity(seq: str) -> list:
    """
    Computes the Lempel-Ziv complexity of a given string sequence.
    Returns the list of distinct substrings used in the parsing process.
    """
    phrases = []  # Initialise an empty list to store unique substrings
    n = len(seq)  # Length of the input sequence

    # Edge case: if the sequence is empty, return the empty list
    if n == 0:
        return phrases

    i = 0  # Start index for scanning the sequences
    while i < n:
        k = 1
        # Check whether `seq[i:i+k]` occurs anywhere in the previous prefix `seq[:i+k-1]`.
        # If it does, increase k. Stop when it's new (not found in the previous prefix)
        while i + k <= n and seq[i:i+k] in seq[:i+k-1]:
            k += 1
        # If we haven't reached the end of the sequence, take `seq[i:i+k]`, else take the remaining tail
        if i + k <= n:
            phrase = seq[i:i+k]
        else:
            phrase = seq[i:n]

        phrases.append(phrase)
        i += len(phrase)

    return phrases  # Return the list of distinct substrings

if __name__ == "__main__":
    # Test sequences
    tests = [
        "AZSEDRFTGYGUJIJOKB",
        "ABCABCABCABCABCABC",
        "111011111001111011111001",
        "101001010010111110",
        "1001111011000010",
        "1010101010",
        "1010101010101010",
        "1001111011000010000010",
        "100111101100001000001010",
        "0001101001000101",
        "1111111",
        "0001",
        "010",
        "1",
        "",
        "01011010001101110010",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!",
    ]

    # Compute and display Lempel-Ziv complexity for each test sequence
    for test in tests:
        subs = lempelZivComplexity(test)
        print(
            f"{test if len(test) != 0 else "<empty>"} -> complexity = {len(subs)}\n"
            f"substrings are: {subs if len(subs) != 0 else None}"
        )
