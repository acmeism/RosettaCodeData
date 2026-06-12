# jaccard_index.py by Xing216
from itertools import product
A = set()
B = {1, 2, 3, 4, 5}
C = {1, 3, 5, 7, 9}
D = {2, 4, 6, 8, 10}
E = {2, 3, 5, 7}
F = {8}
sets = list(product([A, B, C, D, E, F], repeat=2))
set_names = list(product(["A", "B", "C", "D", "E", "F"], repeat=2))
def jaccard_index(set1, set2):
    try:
        return len(set1 & set2)/len(set1 | set2)
    except ZeroDivisionError:
        return 0.0
for i,j in sets:
    jacc_idx = jaccard_index(i,j)
    sets_idx = sets.index((i,j))
    print(f"J({', '.join(set_names[sets_idx])}) -> {jacc_idx}")
