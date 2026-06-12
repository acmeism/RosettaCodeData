from collections import deque

def max_matching(adj):
    """
    Finds maximum matching in a general undirected graph using Edmonds' Blossom algorithm.
    Input: adj — list of lists, adj[u] is the list of neighbors of u (0-indexed).
    Returns: match, size
      match — list where match[u] = v if u–v is in the matching, or -1
      size  — number of matched edges
    """
    n = len(adj)
    match = [-1] * n       # match[u] = v if u is matched to v
    p     = [-1] * n       # parent in the alternating tree
    base  = list(range(n)) # base[u] = base vertex of blossom containing u
    q     = deque()        # queue for BFS
    used  = [False] * n    # whether vertex is in the tree
    blossom = [False] * n  # helper array for marking blossoms

    def lca(a, b):
        """Find least common ancestor of a and b in the forest of alternating tree."""
        used_path = [False] * n
        while True:
            a = base[a]
            used_path[a] = True
            if match[a] == -1: break
            a = p[match[a]]
        while True:
            b = base[b]
            if used_path[b]:
                return b
            b = p[match[b]]

    def mark_path(v, b, x):
        """Mark vertices along the path from v to base b, setting their parent to x."""
        while base[v] != b:
            blossom[base[v]] = blossom[base[match[v]]] = True
            p[v] = x
            x = match[v]
            v = p[x]

    def find_path(root):
        """Try to find an augmenting path starting from root."""
        # reset
        used[:] = [False] * n
        p[:]    = [-1] * n
        for i in range(n):
            base[i] = i
        q.clear()

        used[root] = True
        q.append(root)

        while q:
            v = q.popleft()
            for u in adj[v]:
                # two cases to skip
                if base[v] == base[u] or match[v] == u:
                    continue
                # found a blossom or an odd cycle edge
                if u == root or (match[u] != -1 and p[match[u]] != -1):
                    curbase = lca(v, u)
                    blossom[:] = [False] * n
                    mark_path(v, curbase, u)
                    mark_path(u, curbase, v)
                    # contract blossom
                    for i in range(n):
                        if blossom[base[i]]:
                            base[i] = curbase
                            if not used[i]:
                                used[i] = True
                                q.append(i)
                # otherwise extend the alternating tree
                elif p[u] == -1:
                    p[u] = v
                    if match[u] == -1:
                        # augmenting path found: flip matches along the path
                        curr = u
                        while curr != -1:
                            prev = p[curr]
                            nxt  = match[prev] if prev != -1 else -1
                            match[curr] = prev
                            match[prev] = curr
                            curr = nxt
                        return True
                    # else continue BFS from the matched partner
                    used[match[u]] = True
                    q.append(match[u])
        return False

    # Main loop: try to grow matching by finding augmenting paths
    res = 0
    for v in range(n):
        if match[v] == -1:
            if find_path(v):
                res += 1

    return match, res


if __name__ == "__main__":
    # Example: 5‑cycle (odd cycle)
    # Vertices: 0–1–2–3–4–0
    n = 5
    edges = [(0,1), (1,2), (2,3), (3,4), (4,0)]
    adj = [[] for _ in range(n)]
    for u, v in edges:
        adj[u].append(v)
        adj[v].append(u)

    match, msize = max_matching(adj)
    print(f"Maximum matching size: {msize}")
    print("Matched pairs:")
    seen = set()
    for u, v in enumerate(match):
        if v != -1 and (v, u) not in seen:
            print(f"  {u} – {v}")
            seen.add((u, v))
