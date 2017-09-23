#!/usr/bin/python

import sys, os
import random
import time

def print_there(x, y, text):
     sys.stdout.write("\x1b7\x1b[%d;%df%s\x1b8" % (x, y, text))
     sys.stdout.flush()


class Ball():
    def __init__(self):
        self.x = 0
        self.y = 0

    def update(self):
        self.x += random.randint(0,1)
        self.y += 1

    def fall(self):
        self.y +=1


class Board():
    def __init__(self, width, well_depth, N):
        self.balls = []
        self.fallen = [0] * (width + 1)
        self.width = width
        self.well_depth = well_depth
        self.N = N
        self.shift = 4

    def update(self):
        for ball in self.balls:
            if ball.y < self.width:
                ball.update()
            elif ball.y < self.width + self.well_depth - self.fallen[ball.x]:
                ball.fall()
            elif ball.y == self.width + self.well_depth - self.fallen[ball.x]:
                self.fallen[ball.x] += 1
            else:
                pass

    def balls_on_board(self):
        return len(self.balls) - sum(self.fallen)

    def add_ball(self):
        if(len(self.balls) <= self.N):
            self.balls.append(Ball())

    def print_board(self):
        for y in range(self.width + 1):
            for x in range(y):
                print_there( y + 1 ,self.width - y + 2*x + self.shift + 1, "#")
    def print_ball(self, ball):
        if ball.y <= self.width:
            x = self.width - ball.y + 2*ball.x + self.shift
        else:
            x = 2*ball.x + self.shift
        y = ball.y + 1
        print_there(y, x, "*")

    def print_all(self):
        print(chr(27) + "[2J")
        self.print_board();
        for ball in self.balls:
            self.print_ball(ball)


def main():
    board = Board(width = 15, well_depth = 5, N = 10)
    board.add_ball() #initialization
    while(board.balls_on_board() > 0):
         board.print_all()
         time.sleep(0.25)
         board.update()
         board.print_all()
         time.sleep(0.25)
         board.update()
         board.add_ball()


if __name__=="__main__":
    main()
