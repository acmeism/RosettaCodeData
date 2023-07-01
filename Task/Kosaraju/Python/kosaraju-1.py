def kosaraju(g):
    class nonlocal: pass

    # 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    size = len(g)

    vis = [False]*size # vertexes that have been visited
    l = [0]*size
    nonlocal.x = size
    t = [[]]*size   # transpose graph

    def visit(u):
        if not vis[u]:
            vis[u] = True
            for v in g[u]:
                visit(v)
                t[v] = t[v] + [u]
            nonlocal.x = nonlocal.x - 1
            l[nonlocal.x] = u

    # 2. For each vertex u of the graph do visit(u)
    for u in range(len(g)):
        visit(u)
    c = [0]*size

    def assign(u, root):
        if vis[u]:
            vis[u] = False
            c[u] = root
            for v in t[u]:
                assign(v, root)

    # 3: For each element u of l in order, do assign(u, u)
    for u in l:
        assign(u, u)

    return c

g = [[1], [2], [0], [1,2,4], [3,5], [2,6], [5], [4,6,7]]
print kosaraju(g)
