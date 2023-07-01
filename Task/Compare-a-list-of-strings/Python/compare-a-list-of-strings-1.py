all(a == nexta for a, nexta in zip(strings, strings[1:])) # All equal
all(a < nexta for a, nexta in zip(strings, strings[1:])) # Strictly ascending

len(set(strings)) == 1  # Concise all equal
sorted(strings, reverse=True) == strings  # Concise (but not particularly efficient) ascending
