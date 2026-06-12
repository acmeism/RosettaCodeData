"""Knuth-Morris-Pratt string search. Requires Python >= 3.7."""
from typing import List
from typing import Tuple


def kmp_search(text: str, word: str) -> Tuple[List[int], int]:
    text_position = 0
    word_position = 0

    positions: List[int] = []
    number_of_positions = 0
    table = kmp_table(word)

    while text_position < len(text):
        if word[word_position] == text[text_position]:
            text_position += 1
            word_position += 1
            if word_position == len(word):
                positions.append(text_position - word_position)
                number_of_positions += 1
                word_position = table[word_position]
        else:
            word_position = table[word_position]
            if word_position < 0:
                text_position += 1
                word_position += 1

    return positions, number_of_positions


def kmp_table(word: str) -> List[int]:
    position = 1
    candidate = 0

    table = [0] * (len(word) + 1)
    table[0] = -1

    while position < len(word):
        if word[position] == word[candidate]:
            table[position] = table[candidate]
        else:
            table[position] = candidate
            while candidate >= 0 and word[position] != word[candidate]:
                candidate = table[candidate]
        position += 1
        candidate += 1

    table[position] = candidate
    return table


TEST_CASES = [
    ("GCTAGCTCTACGAGTCTA", "TCTA"),
    ("GGCTATAATGCGTA", "TAATAAA"),
    ("there would have been a time for such a word", "word"),
    ("needle need noodle needle", "needle"),
    (
        (
            "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesley"
            "DKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeand"
            "assemblylanguagestoillustratetheconceptsandalgorithmsastheyare"
            "presented"
        ),
        "put",
    ),
    (
        (
            "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesley"
            "DKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeand"
            "assemblylanguagestoillustratetheconceptsandalgorithmsastheyare"
            "presented"
        ),
        "and",
    ),
    (
        (
            "Nearby farms grew a half acre of alfalfa on the dairy's behalf, "
            "with bales of all that alfalfa exchanged for milk."
        ),
        "alfalfa",
    ),
]


def main():
    for text, word in TEST_CASES:
        positions, number_of_positions = kmp_search(text, word)

        if number_of_positions == 0:
            print(f"`{word}` not found in `{text[:10]}...`")
        elif number_of_positions == 1:
            print(f"Found `{word}` in `{text[:10]}...` once at {positions}.")
        else:
            print(
                f"Found `{word}` in `{text[:10]}...` {number_of_positions} times at {positions}."
            )


if __name__ == "__main__":
    main()
