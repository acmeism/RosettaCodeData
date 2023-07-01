import matplotlib.pyplot as plt
import numpy as np
import turtle as tt

# dictionary containing the first order hilbert curves
base_shape = {'u': [np.array([0, 1]), np.array([1, 0]), np.array([0, -1])],
              'd': [np.array([0, -1]), np.array([-1, 0]), np.array([0, 1])],
              'r': [np.array([1, 0]), np.array([0, 1]), np.array([-1, 0])],
              'l': [np.array([-1, 0]), np.array([0, -1]), np.array([1, 0])]}


def hilbert_curve(order, orientation):
    """
    Recursively creates the structure for a hilbert curve of given order
    """
    if order > 1:
        if orientation == 'u':
            return hilbert_curve(order - 1, 'r') + [np.array([0, 1])] + \
                   hilbert_curve(order - 1, 'u') + [np.array([1, 0])] + \
                   hilbert_curve(order - 1, 'u') + [np.array([0, -1])] + \
                   hilbert_curve(order - 1, 'l')
        elif orientation == 'd':
            return hilbert_curve(order - 1, 'l') + [np.array([0, -1])] + \
                   hilbert_curve(order - 1, 'd') + [np.array([-1, 0])] + \
                   hilbert_curve(order - 1, 'd') + [np.array([0, 1])] + \
                   hilbert_curve(order - 1, 'r')
        elif orientation == 'r':
            return hilbert_curve(order - 1, 'u') + [np.array([1, 0])] + \
                   hilbert_curve(order - 1, 'r') + [np.array([0, 1])] + \
                   hilbert_curve(order - 1, 'r') + [np.array([-1, 0])] + \
                   hilbert_curve(order - 1, 'd')
        else:
            return hilbert_curve(order - 1, 'd') + [np.array([-1, 0])] + \
                   hilbert_curve(order - 1, 'l') + [np.array([0, -1])] + \
                   hilbert_curve(order - 1, 'l') + [np.array([1, 0])] + \
                   hilbert_curve(order - 1, 'u')
    else:
        return base_shape[orientation]


# test the functions
if __name__ == '__main__':
    order = 8
    curve = hilbert_curve(order, 'u')
    curve = np.array(curve) * 4
    cumulative_curve = np.array([np.sum(curve[:i], 0) for i in range(len(curve)+1)])
    # plot curve using plt
    plt.plot(cumulative_curve[:, 0], cumulative_curve[:, 1])
    # draw curve using turtle graphics
    tt.setup(1920, 1000)
    tt.pu()
    tt.goto(-950, -490)
    tt.pd()
    tt.speed(0)
    for item in curve:
        tt.goto(tt.pos()[0] + item[0], tt.pos()[1] + item[1])
    tt.done()
