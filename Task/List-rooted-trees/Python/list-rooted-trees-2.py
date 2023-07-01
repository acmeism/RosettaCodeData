treeid = {(): 0}

'''
Successor of a tree.  The predecessor p of a tree t is:

  1. if the smallest subtree of t is a single node, then p is t minus that node
  2. otherwise, p is t with its smalles subtree "m" replaced by m's predecessor

Here "smaller" means the tree is generated earlier, as recorded by treeid. Obviously,
predecessor to a tree is unique.  Since every degree n tree has a
unique degree (n-1) predecessor, inverting the process leads to the successors
to tree t:

  1. append a single node tree to t's root, or
  2. replace t's smallest subtree by its successors

We need to keep the trees so generated canonical, so when replacing a subtree,
the replacement must not be larger than the next smallest subtree.

Note that trees can be compared by other means, as long as trees with fewer nodes
are considered smaller, and trees with the same number of nodes have a fixed order.
'''
def succ(x):
    yield(((),) + x)
    if not x: return

    if len(x) == 1:
        for i in succ(x[0]): yield((i,))
        return

    head,rest = x[0],tuple(x[1:])
    top = treeid[rest[0]]

    for i in [i for i in succ(head) if treeid[i] <= top]:
        yield((i,) + rest)

def trees(n):
    if n == 1:
        yield()
        return

    global treeid
    for x in trees(n-1):
        for a in succ(x):
            if not a in treeid: treeid[a] = len(treeid)
            yield(a)

def tostr(x): return "(" + "".join(map(tostr, x)) + ")"

for x in trees(5): print(tostr(x))
