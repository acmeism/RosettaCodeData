# After running the above, in the terminal:
from pprint import pprint as pp

for start in 5, 7:
    print(f"EKG({start}):\n[(<next>, [<state>]), ...]")
    pp(([n for n in islice(EKG_gen(start), 21)]))
