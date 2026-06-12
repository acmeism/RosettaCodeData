firstEquation = [3.0,1.0,-1.0] secondEquation = [2.0,-3.0,-19.0]
getCrossingPoint(firstEquation,secondEquation)

func getCrossingPoint(firstEquation,secondEquation)
     x1 = firstEquation[1] y1 = firstEquation[2] r1 = firstEquation[3] x2 = secondEquation[1] y2 = secondEquation[2] r2 = secondEquation[3]
     temp = []
     add(temp,x1) add(temp,-y1) add(temp,r1)
     resultY = ((temp[1]* r2) - (x2 * temp[3])) / ((x2 * temp[2]) + (temp[1]*y2)) resultX = (r1 - (y1*resultY)) / x1
     see "x = " + resultX + nl + "y = " + resultY + nl
