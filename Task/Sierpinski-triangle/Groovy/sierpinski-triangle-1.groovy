def stPoints;
stPoints = { order, base=[0,0] ->
    def right = [base[0], base[1]+2**order]
    def up = [base[0]+2**(order-1), base[1]+2**(order-1)]
    (order == 0) \
        ? [base]
        : (stPoints(order-1, base) + stPoints(order-1, right) + stPoints(order-1, up))
}

def stGrid = { order ->
    def h = 2**order
    def w = 2**(order+1) - 1
    def grid = (0..<h).collect { (0..<w).collect { ' ' } }
    stPoints(order).each { grid[it[0]][it[1]] = (order%10).toString() }
    grid
}
