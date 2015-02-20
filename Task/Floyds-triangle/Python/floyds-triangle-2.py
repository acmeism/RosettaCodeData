def floyd(rowcount=5):
    return [list(range(i*(i-1)//2+1, i*(i+1)//2+1))
            for i in range(1, rowcount+1)]
