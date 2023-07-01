import os
from PIL import Image


def imgsave(path, arr):
    w, h = len(arr), len(arr[0])
    img = Image.new('1', (w, h))
    for x in range(w):
        for y in range(h):
            img.putpixel((x, y), arr[x][y])
    img.save(path)


def get_shape(mat):
    return len(mat), len(mat[0])


def kron(matrix1, matrix2):
    """
    Calculate the kronecker product of two matrices
    """
    final_list = []

    count = len(matrix2)

    for elem1 in matrix1:
        for i in range(count):
            sub_list = []
            for num1 in elem1:
                for num2 in matrix2[i]:
                    sub_list.append(num1 * num2)
            final_list.append(sub_list)

    return final_list


def kronpow(mat):
    """
    Generate an arbitrary number of kronecker powers
    """
    matrix = mat
    while True:
        yield matrix
        matrix = kron(mat, matrix)


def fractal(name, mat, order=6):
    """
    Save fractal as jpg to 'fractals/name'
    """
    path = os.path.join('fractals', name)
    os.makedirs(path, exist_ok=True)

    fgen = kronpow(mat)
    print(name)
    for i in range(order):
        p = os.path.join(path, f'{i}.jpg')
        print('Calculating n =', i, end='\t', flush=True)

        mat = next(fgen)
        imgsave(p, mat)

        x, y = get_shape(mat)
        print('Saved as', x, 'x', y, 'image', p)


test1 = [
    [0, 1, 0],
    [1, 1, 1],
    [0, 1, 0]
]

test2 = [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1]
]

test3 = [
    [1, 0, 1],
    [0, 1, 0],
    [1, 0, 1]
]

fractal('test1', test1)
fractal('test2', test2)
fractal('test3', test3)
