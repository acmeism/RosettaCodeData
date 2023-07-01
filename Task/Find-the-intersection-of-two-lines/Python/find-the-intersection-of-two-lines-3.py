from shapely.geometry import LineString

if __name__ == "__main__":
    line1 = LineString([(4, 0), (6, 10)])
    line2 = LineString([(0, 3), (10, 7)])
    print(line1.intersection(line2))
