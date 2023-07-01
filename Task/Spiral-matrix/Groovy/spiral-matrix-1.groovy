enum Direction {
    East([0,1]), South([1,0]), West([0,-1]), North([-1,0]);
    private static _n
    private final stepDelta
    private bound

    private Direction(delta) {
        stepDelta = delta
    }

    public static setN(int n) {
        Direction._n = n
        North.bound = 0
        South.bound = n-1
        West.bound = 0
        East.bound = n-1
    }

    public List move(i, j) {
        def dir = this
        def newIJDir = [[i,j],stepDelta].transpose().collect { it.sum() } + dir
        if (((North.bound)..(South.bound)).contains(newIJDir[0])
            && ((West.bound)..(East.bound)).contains(newIJDir[1])) {
            newIJDir
        } else {
            (++dir).move(i, j)
        }
    }

    public Object next() {
        switch (this) {
            case North: West.bound++; return East;
            case East: North.bound++; return South;
            case South: East.bound--; return West;
            case West: South.bound--; return North;
        }
    }
}

def spiralMatrix = { n ->
    if (n < 1) return []
    def M = (0..<n).collect { [0]*n }
    def i = 0
    def j = 0
    Direction.n = n
    def dir = Direction.East
    (0..<(n**2)).each { k ->
        M[i][j] = k
        (i,j,dir) = (k < (n**2 - 1)) \
            ? dir.move(i,j) \
            : [i,j,dir]
    }
    M
}
