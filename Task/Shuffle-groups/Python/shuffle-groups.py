import itertools

def shuffleGroups(number: int) -> list[int]:
    return list(map(
        lambda numTuple: int("".join(numTuple)),
        itertools.permutations(str(number))
    ))

def shuffleGroupsWitness(number: int) -> set[int]:
    result = set()
    for group in shuffleGroups(number):
        if group > number and group % number == 0:
            result.add(group//number)
    return result

i = 11
count = 0
breakdown = {}

print("First 20 shuffle groups:\n")
print("| Index | Number | Witness |\n| ----: | :----: | :-----: |")
while True:
    if i > 9 and i % 10 == 0:
        i += 1
        continue

    witness = shuffleGroupsWitness(i)
    witnessCount = len(witness)
    if witnessCount > 0:
        if breakdown.get(witnessCount) is None:
            breakdown[witnessCount] = 0
        breakdown[witnessCount] += 1
        count += 1
    else:
        i += 1
        continue

    if count <= 20:
        print(f"|{count:>6} |{i:^8}|{list(witness)[0]:^9}|")

    if len(witness) > 4:
        witnessString = ", ".join(map(str, witness))
        padding = len(witnessString) + 2
        print("\nFirst shuffle group with more than 4 witnesses:\n")
        print(f"| Index | Number |{"Witness":^{padding}}|\n| ----: | :----: | :{"-":-^{padding-4}}: |")
        print(f"|{count:>6} |{i:^8}|{witnessString:^{padding}}|")

        print(f"\nFor the first {count} shuffle groups, there are:\n")
        for key, val in breakdown.items():
            print(f"* {val} with **{key}** witness{"es" if key > 1 else ""}")

        break

    i += 1
