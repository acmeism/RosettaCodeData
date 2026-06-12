from random import choice
import regex as re
import time

def generate_sequence(n: int ) -> str:
    return "".join([ choice(['A','C','G','T']) for _ in range(n) ])

def dna_findall(needle: str, haystack: str) -> None:

    if sum(1 for _ in re.finditer(needle, haystack, overlapped=True)) == 0:
        print("No matches found")
    else:
        print(f"Found {needle} at the following indices: ")
        for match in re.finditer(needle, haystack, overlapped=True):
            print(f"{match.start()}:{match.end()} ")

dna_seq = generate_sequence(200)
sample_seq = generate_sequence(4)

c = 1
for i in dna_seq:
    print(i, end="") if c % 20 != 0 else print(f"{i}")
    c += 1
print(f"\nSearch Sample: {sample_seq}")

dna_findall(sample_seq, dna_seq)
