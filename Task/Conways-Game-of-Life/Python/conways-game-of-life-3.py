import numpy as np
from pandas import DataFrame
import matplotlib.pyplot as plt
#import time

def conway_life(len=10, wid=10, gen=5):

    curr_gen = DataFrame(np.random.randint(0, 2, (len+2, wid+2)),
                         index = range(len+2),
                         columns = range(wid+2))
    curr_gen[0] = 0
    curr_gen[wid+1] = 0
    curr_gen[0: 1] = 0
    curr_gen[len+1: len+2] = 0

    for i in range(gen):

        fig, ax = plt.subplots()
        draw = curr_gen[1:len+1].drop([0, wid+1], axis=1)
        # 画图

        image = draw
        ax.imshow(image, cmap=plt.cm.cool, interpolation='nearest')
        ax.set_title("Conway's game of life.")

        # Move left and bottom spines outward by 10 points
        ax.spines['left'].set_position(('outward', 10))
        ax.spines['bottom'].set_position(('outward', 10))
        # Hide the right and top spines
        ax.spines['right'].set_visible(False)
        ax.spines['top'].set_visible(False)
        # Only show ticks on the left and bottom spines
        ax.yaxis.set_ticks_position('left')
        ax.xaxis.set_ticks_position('bottom')

        plt.show()
        # time.sleep(1)


        # 初始化空表
        next_gen = DataFrame(np.random.randint(0, 1, (len+2, wid+2)),
                             index = range(len+2),
                             columns = range(wid+2))


        # 生成下一代
        for x in range(1, wid+1):
            for y in range(1, len+1):
                env = (curr_gen[x-1][y-1] + curr_gen[x][y-1] +
                       curr_gen[x+1][y-1]+ curr_gen[x-1][y] +
                       curr_gen[x+1][y] + curr_gen[x-1][y+1] +
                       curr_gen[x][y+1] + curr_gen[x+1][y+1])

                if (not curr_gen[x][y] and env == 3):
                    next_gen[x][y] = 1
                if (curr_gen[x][y] and env in (2, 3)):
                    next_gen[x][y] = 1

        curr_gen = next_gen


conway_life()
