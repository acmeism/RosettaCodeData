import os

from collections import Counter
from functools import reduce
from itertools import permutations

BASES = ("A", "C", "G", "T")


def deduplicate(sequences):
    """Return the set of sequences with those that are a substring
    of others removed too."""
    sequences = set(sequences)
    duplicates = set()

    for s, t in permutations(sequences, 2):
        if s != t and s in t:
            duplicates.add(s)

    return sequences - duplicates


def smash(s, t):
    """Return `s` concatenated with `t`. The longest suffix of `s`
    that matches a prefix of `t` will be removed."""
    for i in range(len(s)):
        if t.startswith(s[i:]):
            return s[:i] + t
    return s + t


def shortest_superstring(sequences):
    """Return the shortest superstring covering all sequences. If
    there are multiple shortest superstrings, an arbitrary
    superstring is returned."""
    sequences = deduplicate(sequences)
    shortest = "".join(sequences)

    for perm in permutations(sequences):
        superstring = reduce(smash, perm)
        if len(superstring) < len(shortest):
            shortest = superstring

    return shortest


def shortest_superstrings(sequences):
    """Return a list of all shortest superstrings that cover
    `sequences`."""
    sequences = deduplicate(sequences)

    shortest = set(["".join(sequences)])
    shortest_length = sum(len(s) for s in sequences)

    for perm in permutations(sequences):
        superstring = reduce(smash, perm)
        superstring_length = len(superstring)
        if superstring_length < shortest_length:
            shortest.clear()
            shortest.add(superstring)
            shortest_length = superstring_length
        elif superstring_length == shortest_length:
            shortest.add(superstring)

    return shortest


def print_report(sequence):
    """Writes a report to stdout for the given DNA sequence."""
    buf = [f"Nucleotide counts for {sequence}:\n"]

    counts = Counter(sequence)
    for base in BASES:
        buf.append(f"{base:>10}{counts.get(base, 0):>12}")

    other = sum(v for k, v in counts.items() if k not in BASES)
    buf.append(f"{'Other':>10}{other:>12}")

    buf.append(" " * 5 + "_" * 17)
    buf.append(f"{'Total length':>17}{sum(counts.values()):>5}")

    print(os.linesep.join(buf), "\n")


if __name__ == "__main__":
    test_cases = [
        ("TA", "AAG", "TA", "GAA", "TA"),
        ("CATTAGGG", "ATTAG", "GGG", "TA"),
        ("AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"),
        (
            "ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
            "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
            "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
            "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
            "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
            "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
            "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
            "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
            "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
            "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
            "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
            "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
            "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA",
        ),
    ]

    for case in test_cases:
        for superstring in shortest_superstrings(case):
            print_report(superstring)

    # or ..
    #
    # for case in test_cases:
    #     print_report(shortest_superstring(case))
    #
    # .. if you don't want all possible shortest superstrings.
