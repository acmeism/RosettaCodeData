def min_cells_matrix(siz):
    return [[min(row, col, siz - row - 1, siz - col - 1) for col in range(siz)] for row in range(siz)]

def display_matrix(mat):
    siz = len(mat)
    spaces = 2 if siz < 20 else 3 if siz < 200 else 4
    print(f"\nMinimum number of cells after, before, above and below {siz} x {siz} square:")
    for row in range(siz):
        print("".join([f"{n:{spaces}}" for n in mat[row]]))

def test_min_mat():
    for siz in [23, 10, 9, 2, 1]:
        display_matrix(min_cells_matrix(siz))

if __name__ == "__main__":
    test_min_mat()
