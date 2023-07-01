import std.stdio;

void main() {
    int[][] weights = [
        [1, 3, -2],
        [2, 1, 4],
        [2, 3, 3],
        [3, 4, 2],
        [4, 2, -1]
    ];
    int numVertices = 4;

    floydWarshall(weights, numVertices);
}

void floydWarshall(int[][] weights, int numVertices) {
    import std.array;

    real[][] dist = uninitializedArray!(real[][])(numVertices, numVertices);
    foreach(dim; dist) {
        dim[] = real.infinity;
    }

    foreach (w; weights) {
        dist[w[0]-1][w[1]-1] = w[2];
    }

    int[][] next = uninitializedArray!(int[][])(numVertices, numVertices);
    for (int i=0; i<next.length; i++) {
        for (int j=0; j<next.length; j++) {
            if (i != j) {
                next[i][j] = j+1;
            }
        }
    }

    for (int k=0; k<numVertices; k++) {
        for (int i=0; i<numVertices; i++) {
            for (int j=0; j<numVertices; j++) {
                if (dist[i][j] > dist[i][k] + dist[k][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                    next[i][j] = next[i][k];
                }
            }
        }
    }

    printResult(dist, next);
}

void printResult(real[][] dist, int[][] next) {
    import std.conv;
    import std.format;

    writeln("pair     dist    path");
    for (int i=0; i<next.length; i++) {
        for (int j=0; j<next.length; j++) {
            if (i!=j) {
                int u = i+1;
                int v = j+1;
                string path = format("%d -> %d    %2d     %s", u, v, cast(int) dist[i][j], u);
                do {
                    u = next[u-1][v-1];
                    path ~= text(" -> ", u);
                } while (u != v);
                writeln(path);
            }
        }
    }
}
