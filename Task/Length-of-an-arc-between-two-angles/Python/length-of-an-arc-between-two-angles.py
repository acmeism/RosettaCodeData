import math

def arc_length(r, angleA, angleB):
    return (360.0 - abs(angleB - angleA)) * math.pi * r / 180.0

radius = 10
angleA = 10
angleB = 120

result = arc_length(radius, angleA, angleB)
print(result)
