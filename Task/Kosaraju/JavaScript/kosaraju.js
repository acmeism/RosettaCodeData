function kosaraju(g) {
    const size = g.length;
    const vis = new Array(size).fill(false);
    const l = new Array(size);
    let x = size - 1;
    const t = Array.from({ length: size }, () => []);

    // Recursive visit function
    const visit = (u) => {
        if (!vis[u]) {
            vis[u] = true;
            for (const v of g[u]) {
                visit(v);
                t[v].push(u);
            }
            l[x] = u;
            x--;
        }
    };

    // Step 2: Visit each vertex
    for (let i = 0; i < size; i++) {
        visit(i);
    }

    const c = new Array(size).fill(0);

    // Recursive assign function
    const assign = (u, root) => {
        if (vis[u]) { // repurpose vis to mean 'unassigned'
            vis[u] = false;
            c[u] = root;
            for (const v of t[u]) {
                assign(v, root);
            }
        }
    };

    // Step 3: Assign components
    for (const u of l) {
        assign(u, u);
    }

    return c;
}

// Example usage
const g = Array.from({ length: 8 }, () => []);
g[0].push(1);
g[1].push(2);
g[2].push(0);
g[3].push(1, 2, 4);
g[4].push(3, 5);
g[5].push(2, 6);
g[6].push(5);
g[7].push(4, 6, 7);

const output = kosaraju(g);
console.log(output);
