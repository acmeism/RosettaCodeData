#!/usr/bin/python

firstEquation  = [ 3, 1, -1]
secondEquation = [ 2,-3,-19]

def getCrossingPoint(firstEquation, secondEquation):
    x1 = firstEquation[0]
    y1 = firstEquation[1]
    r1 = firstEquation[2]
    x2 = secondEquation[0]
    y2 = secondEquation[1]
    r2 = secondEquation[2]
    temp = []
    temp.append( x1)
    temp.append(-y1)
    temp.append( r1)
    resultY = ((temp[0]*r2) - (x2*temp[2])) / ((x2*temp[1]) + (temp[0]*y2))
    resultX = (r1 - (y1*resultY)) / x1
    print("x = ", resultX)
    print("y = ", resultY)


if __name__ == "__main__":
    getCrossingPoint(firstEquation, secondEquation)
