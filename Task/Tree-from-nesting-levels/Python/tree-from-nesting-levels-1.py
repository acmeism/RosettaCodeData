def to_tree(x, index=0, depth=1):
   so_far = []
   while index < len(x):
       this = x[index]
       if this == depth:
           so_far.append(this)
       elif this > depth:
           index, deeper = to_tree(x, index, depth + 1)
           so_far.append(deeper)
       else: # this < depth:
           index -=1
           break
       index += 1
   return (index, so_far) if depth > 1 else so_far


if __name__ ==  "__main__":
    from pprint import pformat

    def pnest(nest:list, width: int=9) -> str:
        text = pformat(nest, width=width).replace('\n', '\n    ')
        print(f" OR {text}\n")

    exercises = [
        [],
        [1, 2, 4],
        [3, 1, 3, 1],
        [1, 2, 3, 1],
        [3, 2, 1, 3],
        [3, 3, 3, 1, 1, 3, 3, 3],
        ]
    for flat in exercises:
        nest = to_tree(flat)
        print(f"{flat} NESTS TO: {nest}")
        pnest(nest)
