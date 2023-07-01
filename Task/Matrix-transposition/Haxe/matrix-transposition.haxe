class Matrix {
    static function main() {
        var m = [ [1,  1,   1,   1],
                  [2,  4,   8,  16],
                  [3,  9,  27,  81],
                  [4, 16,  64, 256],
                  [5, 25, 125, 625] ];
        var t = [ for (i in 0...m[0].length)
                      [ for (j in 0...m.length) 0 ] ];
        for(i in 0...m.length)
            for(j in 0...m[0].length)
                t[j][i] = m[i][j];

        for(aa in [m, t])
            for(a in aa) Sys.println(a);
    }
}
