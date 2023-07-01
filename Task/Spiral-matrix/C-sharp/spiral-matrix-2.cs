//generate spiral matrix for given N
int[,] CreateMatrix(int n){
    int[] dx = {0, 1, 0, -1}, dy = {1, 0, -1, 0};
    int x = 0, y = -1, c = 0;
    int[,] m = new int[n,n];
    for (int i = 0, im = 0; i < n + n - 1; ++i, im = i % 4)
        for (int j = 0, jlen = (n + n - i) / 2; j < jlen; ++j)
            m[x += dx[im],y += dy[im]] = ++c;
    return n;
}

//print aligned matrix
void Print(int[,] matrix) {
    var len = (int)Math.Ceiling(Math.Log10(m.GetLength(0) * m.GetLength(1)))+1;
    for(var y = 0; y<m.GetLength(1); y++){
        for(var x = 0; x<m.GetLength(0); x++){
            Console.Write(m[y, x].ToString().PadRight(len, ' '));
        }
        Console.WriteLine();
    }
}
