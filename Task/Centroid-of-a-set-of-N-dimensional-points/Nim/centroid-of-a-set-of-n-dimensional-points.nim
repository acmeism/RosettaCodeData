type Coords[N: static Positive] = array[N, float]


proc centroid(points: openArray[Coords]): Coords =
  ## Return the coordinates of the centroid of the given points.
  for point in points:
    for i, coord in point:
      result[i] += coord
  for coord in result.mitems:
    coord /= points.len.toFloat


proc displayCentroid(points: openArray[Coords]) =
  echo "Set: ", points
  echo "Centroid: ", points.centroid
  echo()


const
  Points1: seq[Coords[1]] = @[[1], [2], [3]]
  Points2: seq[Coords[2]] = @[[8, 2], [0, 0]]
  Points3: seq[Coords[3]] = @[[5, 5, 0], [10, 10, 0]]
  Points4: seq[Coords[3]] = @[[1, 3.1, 6.5], [-2, -5, 3.4], [-7, -4, 9], [2, 0, 3]]
  Points5: seq[Coords[5]] = @[[0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0]]

Points1.displayCentroid()
Points2.displayCentroid()
Points3.displayCentroid()
Points4.displayCentroid()
Points5.displayCentroid()
