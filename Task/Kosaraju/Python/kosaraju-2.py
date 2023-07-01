def kosaraju(g):
    size = len(g)
    vis = [False] * size
    l = [0] * size
    x = size
    t = [[] for _ in range(size)]

    def visit(u):
        nonlocal x
        if not vis[u]:
            vis[u] = True
            for v in g[u]:
                visit(v)
                t[v].append(u)
            x -= 1
            l[x] = u

    for u in range(size):
        visit(u)
    c = [0] * size

    def assign(u, root):
        if vis[u]:
            vis[u] = False
            c[u] = root
            for v in t[u]:
                assign(v, root)

    for u in l:
        assign(u, u)

    return c


g = [[1], [2], [0], [1, 2, 4], [3, 5], [2, 6], [5], [4, 6, 7]]
print(kosaraju(g))
