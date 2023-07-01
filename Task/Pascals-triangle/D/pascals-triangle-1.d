int[][] pascalsTriangle(in int rows) pure nothrow {
    auto tri = new int[][rows];
    foreach (r; 0 .. rows) {
        int v = 1;
        foreach (c; 0 .. r+1) {
            tri[r] ~= v;
            v = (v * (r - c)) / (c + 1);
        }
    }
    return tri;
}

void main() {
    immutable t = pascalsTriangle(10);
    assert(t == [[1],
                [1, 1],
               [1, 2, 1],
             [1, 3, 3, 1],
           [1, 4, 6, 4, 1],
         [1, 5, 10, 10, 5, 1],
       [1, 6, 15, 20, 15, 6, 1],
     [1, 7, 21, 35, 35, 21, 7, 1],
    [1, 8, 28, 56, 70, 56, 28, 8, 1],
  [1, 9, 36, 84, 126, 126, 84, 36, 9, 1]]);
}
