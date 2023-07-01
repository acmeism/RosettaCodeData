n = 20
mappings = {3: "Fizz", 5: "Buzz", 7: "Baxx"}
for i in range(1, n+1): print(''.join(word * (i % key == 0) for key, word in mappings.items()) or i)
