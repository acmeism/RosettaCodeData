""" For Rosetta Code task N-queens_minimum_and_knights_and_bishops """

from mip import Model, BINARY, xsum, minimize

def n_queens_min(N):
    """ N-queens minimum problem, oeis.org/A075458 """
    if N < 4:
        brd = [[0 for i in range(N)] for j in range(N)]
        brd[0 if N < 2 else 1][0 if N < 2 else 1] = 1
        return 1, brd

    model = Model()
    board = [[model.add_var(var_type=BINARY) for j in range(N)] for i in range(N)]
    for k in range(N):
        model += xsum(board[k][j] for j in range(N)) <= 1
        model += xsum(board[i][k] for i in range(N)) <= 1

    for k in range(1, 2 * N - 2):
        model += xsum(board[k - j][j] for j in range(max(0, k - N + 1), min(k + 1, N))) <= 1

    for k in range(2 - N, N - 1):
        model += xsum(board[k + j][j] for j in range(max(0, -k), min(N - k, N))) <= 1

    for i in range(N):
        for j in range(N):
            model += xsum([xsum(board[i][k] for k in range(N)),
               xsum(board[k][j] for k in range(N)),
               xsum(board[i + k][j + k] for k in range(-N, N)
                  if 0 <= i + k < N and 0 <= j + k < N),
               xsum(board[i - k][j + k] for k in range(-N, N)
                  if 0 <= i - k < N and 0 <= j + k < N)]) >= 1

    model.objective = minimize(xsum(board[i][j] for i in range(N) for j in range(N)))
    model.optimize()
    return model.objective_value, [[board[i][j].x for i in range(N)] for j in range(N)]


def n_bishops_min(N):
    """ N-Bishops minimum problem (returns N)"""
    model = Model()
    board = [[model.add_var(var_type=BINARY) for j in range(N)] for i in range(N)]

    for i in range(N):
        for j in range(N):
            model += xsum([
               xsum(board[i + k][j + k] for k in range(-N, N)
                  if 0 <= i + k < N and 0 <= j + k < N),
               xsum(board[i - k][j + k] for k in range(-N, N)
                  if 0 <= i - k < N and 0 <= j + k < N)]) >= 1

    model.objective = minimize(xsum(board[i][j] for i in range(N) for j in range(N)))
    model.optimize()
    return model.objective_value, [[board[i][j].x for i in range(N)] for j in range(N)]

def n_knights_min(N):
    """ N-knights minimum problem, oeis.org/A342576 """
    if N < 2:
        return 1, "N"

    knightdeltas = [(1, 2), (2, 1), (2, -1), (1, -2), (-1, -2), (-2, -1), (-2, 1), (-1, 2)]
    model = Model()
    # to simplify the constraints, embed the board of size N inside a board of size N + 4
    board = [[model.add_var(var_type=BINARY) for j in range(N + 4)] for i in range(N + 4)]
    for i in range(N + 4):
        model += xsum(board[i][j] for j in [0, 1, N + 2, N + 3]) == 0
    for j in range(N + 4):
        model += xsum(board[i][j] for i in [0, 1, N + 2, N + 3]) == 0

    for i in range(2, N + 2):
        for j in range(2, N + 2):
            model += xsum([board[i][j]] + [board[i + d[0]][j + d[1]]
               for d in knightdeltas]) >= 1
            model += xsum([board[i + d[0]][j + d[1]]
               for d in knightdeltas] + [100 * board[i][j]]) <= 100

    model.objective = minimize(xsum(board[i][j] for i in range(2, N + 2) for j in range(2, N + 2)))
    model.optimize()
    minresult = model.objective_value
    return minresult, [[board[i][j].x for i in range(2, N + 2)] for j in range(2, N + 2)]


if __name__ == '__main__':
    examples, pieces, chars = [[], [], []], ["Queens", "Bishops", "Knights"], ['Q', 'B', 'N']
    print("   Squares    Queens   Bishops   Knights")
    for nrows in range(1, 11):
        print(str(nrows * nrows).rjust(10), end='')
        minval, examples[0] = n_queens_min(nrows)
        print(str(int(minval)).rjust(10), end='')
        minval, examples[1] = n_bishops_min(nrows)
        print(str(int(minval)).rjust(10), end='')
        minval, examples[2] = n_knights_min(nrows)
        print(str(int(minval)).rjust(10))
        if nrows == 10:
            print("\nExamples for N = 10:")
            for idx, piece in enumerate(chars):
                print(f"\n{pieces[idx]}:")
                for row in examples[idx]:
                    for sqr in row:
                        print(chars[idx] if sqr == 1 else '.', '', end = '')
                    print()
                print()
