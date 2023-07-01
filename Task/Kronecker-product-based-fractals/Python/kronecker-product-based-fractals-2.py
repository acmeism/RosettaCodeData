import os
import numpy as np
from scipy.sparse import csc_matrix, kron
from scipy.misc import imsave


def imgsave(name, arr, *args):
    imsave(name, arr.toarray(), *args)


def get_shape(mat):
    return mat.shape


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

test1 = np.array(test1, dtype='int8')
test1 = csc_matrix(test1)

test2 = np.array(test2, dtype='int8')
test2 = csc_matrix(test2)

test3 = np.array(test3, dtype='int8')
test3 = csc_matrix(test3)

fractal('test1', test1)
fractal('test2', test2)
fractal('test3', test3)
