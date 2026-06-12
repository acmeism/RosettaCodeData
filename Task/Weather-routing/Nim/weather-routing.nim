import hashes, math, parsecsv, sequtils, sets, strutils, sugar

type
  MatrixF = seq[seq[float]]
  Pred = float -> bool

  # Structure that represents a polar CSV file's data.
  # Note 0 degrees is directly into the wind, 180 degrees is directly downwind.
  SailingPolar = object
    winds: seq[float]     # Vector of windspeeds.
    degrees: seq[float]   # Vector of angles in degrees of direction relative to the wind.
    speeds: MatrixF       # Matrix of sailing speeds indexed by wind velocity and angle of boat to wind.

  # Structure that represents wind and surface current direction and velocity for a given position.
  # Angles in degrees, velocities in knots.
  SurfaceParameters = tuple[windDeg, windKts, currentDeg, currentKts: float]


proc getPolarData(filename: string): SailingPolar =
  ## Reads a sailing polar CSV file and returns a SailingPolar struct containing the file data.
  ## A sailing polar file is a CSV file, with ';' used as the comma separator instead of a comma.
  ## The first line of file contains labels for the wind velocities that make up columns, and
  ## the first entry of each row makes up a column of angle of sailing direction from wind in degrees.
  var parser: CsvParser
  parser.open(filename, separator = ';')
  parser.readHeaderRow()
  for col in 1..parser.headers.high:
    result.winds.add parser.headers[col].parseFloat()
  while parser.readRow():
    if parser.row.len == 0: break # Ignore final blank line if there is one.
    result.degrees.add parser.row[0].parseFloat()
    result.speeds.add @[]
    for col in 1..parser.row.high:
      result.speeds[^1].add parser.row[col].parseFloat()


const R = 6372800.0 # Earth's approximate radius in meters.

template sind(d: float): float = sin(degToRad(d))
template cosd(d: float): float = cos(degToRad(d))
template asind(x: float): float = radToDeg(arcsin(x))
template atand(x, y: float): float = radToDeg(arctan2(x, y))


func haversine(lat1, long1, lat2, long2: float): (float, float) =
  ## Calculates the Haversine function for two points on the Earth's surface.
  ## Given two latitude, longitude pairs in degrees for a point on the Earth,
  ## get distance in meters and the initial direction of travel in degrees for
  ## movement from point 1 to point 2.
  let dlat = lat2 - lat1
  let dlong = long2 - long1
  let a = sind(dlat/2)^2 + cosd(lat1) * cosd(lat2) * sind(dlong/2)^2
  let c = 2 * asind(sqrt(a))
  var theta = atand(sind(dlong) * cosd(lat2),
                    cosd(lat1) * sind(lat2) - sind(lat1) * cosd(lat2) * cosd(dlong))
  theta = (theta + 360) mod 360
  result = (R * c * 0.5399565, theta)


func findFirst(a: seq[float]; p: Pred): int =
  ## Returns the index of the first element of 'a' for which 'p' returns true or -1 otherwise.
  for i in 0..a.high:
    if p(a[i]): return i
  result = -1


func findLast(a: seq[float]; p: Pred): int =
  ## Returns the index of the last element of 'a' for which 'p' returns true or -1 otherwise.
  for i in countdown(a.high, 0):
    if p(a[i]): return i
  result = -1


func boatSpeed(sp: SailingPolar; pointOfSail, windSpeed: float): float =
  ## Calculate the expected sailing speed in a specified direction in knots,
  ## given sailing polar data, a desired point of sail in degrees, and wind speed in knots.
  let
    udeg = sp.degrees.findLast(t => t <= pointOfSail)
    odeg = sp.degrees.findFirst(t => t >= pointOfSail)
    uvel = sp.winds.findLast(t => t <= windSpeed)
    ovel = sp.winds.findFirst(t => t >= windSpeed)
  if udeg == -1 or odeg == -1 or uvel == -1 or ovel == -1: return -1
  let frac = if odeg == udeg and uvel == ovel:
               1.0
             elif odeg == udeg:
               (windSpeed - sp.winds[uvel]) / (sp.winds[ovel] - sp.winds[uvel])
             elif uvel == ovel:
               (pointOfSail - sp.degrees[udeg]) / (sp.degrees[odeg] - sp.degrees[udeg])
             else:
               ((pointOfSail - sp.degrees[udeg]) / (sp.degrees[odeg] - sp.degrees[udeg]) +
               (windSpeed - sp.winds[uvel]) / (sp.winds[ovel] - sp.winds[uvel])) / 2
  result = sp.speeds[udeg][uvel] + frac * (sp.speeds[odeg][ovel] - sp.speeds[udeg][uvel])


func sailingSpeed(sp: SailingPolar; azimuth, pointos, ws: float): float =
  ## Calculates the expected net boat speed in a desired direction versus the wind ('azimuth').
  ## This is generally different from the actual boat speed in its actual direction.
  ## Directions are in degrees ('pointos' is point of sail the ship direction from the wind),
  ## and velocity of wind ('ws') is in knots.
  sp.boatSpeed(pointos, ws) * cosd(abs(pointos - azimuth))


func bestVectorSpeed(sp: SailingPolar;
                     dirTravel, dirWind, windSpeed, dirCur, velCur: float): (float, float) =
  ## Calculates the net direction and velocity of a sailing ship.
  ## Arguments are sailing polar data, direction of travel in degrees from north, wind direction in
  ## degrees from north, wind velocity in knots, surface current direction in degrees, and
  ## current velocity in knots.
  var azimuth = (dirTravel - dirWind) mod 360
  if azimuth < 0: azimuth += 360
  if azimuth > 180: azimuth = 360 - azimuth

  var vmg = sp.boatSpeed(azimuth, windSpeed)
  var other = -1.0
  var idx = -1
  for i, d in sp.degrees:
    let ss = sp.sailingSpeed(azimuth, d, windSpeed)
    if ss > other:
      other = ss
      idx = i
  if other > vmg:
    azimuth = sp.degrees[idx]
    vmg = other

  let
    dirChosen = dirWind + azimuth
    wx = vmg * sind(dirChosen)
    wy = vmg * cosd(dirChosen)
    curX = velCur * sind(dirCur)
    curY = velCur * cosd(dirCur)
  result = (atand(wy + curY, wx + curX), sqrt((wx + curX)^2 + (wy + curY)^2))


func sailSegmentTime(sp: SailingPolar; p: SurfaceParameters;
                     lat1, long1, lat2, long2: float): float =
  ## Calculates the trip time in minutes from (lat1, long1) to the destination (lat2, long2).
  ## Uses the data in SurfaceParameters for wind and current velocity and direction.
  let (distance, dir) = haversine(lat1, long1, lat2, long2)
  let (_, vel) = sp.bestVectorSpeed(dir, p.windDeg, p.windKts, p.currentDeg, p.currentKts)
  ## minutes/s * m / (knots * (m/s / knot)) = minutes
  result = (1 / 60) * distance / (vel * 1.94384)


# Structure that represents a point in 2-D space.
type Point2 = tuple[x, y: int]

func `+`(p1, p2: Point2): Point2 = (p1.x + p2.x, p1.y + p2.y)

func `$`(p: Point2): string = "($1, $2)".format(p.x, p.y)


type

  # Tuple that consists of a tuple of latitude and longitude in degrees.
  # NB: This uses latitude (often considered to be y) first then longitude (often considered to be x).
  # This latitude, then longitude ordering is as per ISO 6709 (en.wikipedia.org/wiki/ISO_6709).
  Position = tuple[lat, long: float]

  # Tuple that represents a Position with the SurfaceParameters of wind and current at the Position.
  GridPoint = tuple[pt: Position; sp: SurfaceParameters]

  MatrixG = seq[seq[GridPoint]]

  # Type alias for a matrix of GridPoints, each Position point with their SurfaceParameters.
  # A vector of TimeSlice can give the surface characteristics for an ocean region over time.
  TimeSlice = MatrixG

  # Structure that represents a routing problem.
  RoutingProblem = object
    timeInterval: float           # The minutes duration for each TimeSlice.
    timeFrame: seq[TimeSlice]     # A vector of sequential timeslices for the ocean region.
    obstacleIndices: seq[Point2]  # The cartesian indices in each TimeSlice for obstacles
                                  # such as land or shoals, where the ship may not go.
    startIndex: int               # The TimeSlice position for time of starting.
    start: Point2                 # Starting location on grid of GridPoints.
    finish: Point2                # Destination / finish location on grid of GridPoints.
    allowRepeatVisits: bool       # Whether the vessel may overlap its prior path, usually false.

  # Structure that represents a timed path.
  TimedPath = object
    duration: float     # Minutes total to travel the path.
    path: seq[Point2]   # Vector of cartesian indices of points in grid for path to travel.


func hash(t: TimedPath): Hash =
  ## Hash function to allow building a set of TimedPath values.
  result = t.duration.hash !& t.path.hash
  result = !$result


const Neighbors: seq[Point2] = @[(-1, -1), (-1,  0), (-1, 1), (0, -1),
                                 ( 0,  1), ( 1, -1), ( 1, 0), (1,  1)]

func surround(p: Point2; mat: TimeSlice; excluded: openArray[Point2]): seq[Point2] =
  ## Returns a list of points surrounding 'p' which are not otherwise excluded.
  let xmax = mat.len
  let ymax = mat[0].len
  for x in Neighbors:
    let q = p + x
    if q.x >= 0 and q.x < xmax and q.y >= 0 and q.y < ymax and q notin excluded:
      result.add q


proc minimumTimeRoute(rp: RoutingProblem; sp: SailingPolar; verbose: bool): TimedPath =
  ## Get the route (as a TimedPath) that minimizes time from start to finish for a given
  ## RoutingProblem (sea parameters) given sailing polar data (ship parameters).

  var timedPaths = @[TimedPath(duration: 0, path: @[rp.start])]
  var completed = false
  result = TimedPath(duration: 1000)
  for _ in 1..1000:

    var newPaths: seq[TimedPath]
    if verbose:
      echo "Checking $1 paths of length $2".format(timedPaths.len, timedPaths[0].path.len)
    for tpath in timedPaths:
      if tpath.path[^1] == rp.finish:
        completed = true
        newPaths.add tpath
      else:
        let p1 = tpath.path[^1]
        let num = tpath.duration.toInt
        let den = rp.timeInterval.toInt
        let slice = rp.timeFrame[num div den mod rp.timeFrame.len]
        for p2 in p1.surround(slice, rp.obstacleIndices):
          if not rp.allowRepeatVisits and p2 in tpath.path:
            continue
          let gp1 = slice[p1.x][p1.y]
          let gp2 = slice[p2.x][p2.y]
          let (lat1, long1) = gp1.pt
          let (lat2, long2) = gp2.pt
          let t = sp.sailSegmentTime(gp1.sp, lat1, long1, lat2, long2)
          let path = tpath.path & p2
          newPaths.add TimedPath(duration: tpath.duration + t, path: path)

    timedPaths = newPaths.toHashSet().toSeq()
    if completed:
      var durations = collect(newSeq, for t in timedPaths: t.duration)
      let minDur = min(durations)
      let finished = collect(newSeq):
                       for t in timedPaths:
                         if t.path[^1] == rp.finish: t
      durations = collect(newSeq, for f in finished: f.duration)
      let idx = minIndex(durations)
      let minFinDur = durations[idx]
      if verbose:
        echo "Current finished minimum: $1, others $2".format(finished[idx], minDur)
      if minDur == minFinDur:
        result = finished[idx]
        break


#[ The data is selected so the best time path is slightly longer than the
   shortest length path. The forbidden regions are x, representing land or reef.
   The allowed sailing points are . and start and finish are S and F.

   x  .  .  F  .  .  x  .  x
   .  .  .  .  .  .  .  x  x
   x  .  .  x  x  x  .  .  .
   .  .  x  x  x  x  .  x  x
   x  .  .  .  x  x  .  x  .
   x  .  .  .  x  x  .  x  .
   .  .  .  .  x  .  .  x  .
   x  .  .  .  .  .  .  x  .
   .  .  .  S  .  .  .  .  .
]#


const Forbidden: seq[Point2] = @[(0, 7), (1, 0), (1, 7), (2, 4), (2, 7), (3, 0), (3, 4),
                                 (3, 5), (3, 7), (4, 0), (4, 4), (4, 5), (4, 7), (5, 2),
                                 (5, 3), (5, 4), (5, 5), (5, 7), (5, 8), (6, 0), (6, 3),
                                 (6, 4), (6, 5), (7, 7), (7, 8), (8, 0), (8, 6), (8, 8)]


func surfaceByLongitude(long: float): SurfaceParameters =
  ## Create regional wind patterns on the map.
  if long < -155.03:
    (-5.0, 8.0, 150.0, 0.5)
  elif long < -155.99:
    (-90.0, 20.0, 150.0, 0.4)
  else:
    (180.0, 25.0, 150.0, 0.3)


func mutateTimeSlices(slices: var seq[TimeSlice]) =
  var i = 1
  for slice in slices.mitems:
    for j in 0..slice.high:
      for x in slice[j].mitems:
        x.sp = (x.sp.windDeg, x.sp.windKts * (1 + 0.002 * float64(i)),
                x.sp.currentDeg, x.sp.currentKts)
    inc i


let startPos: Point2 = (0, 3)
let endPos: Point2 = (8, 3)
var slices = newSeq[MatrixG](200)

for s in 0..slices.high:
  var gpoints = newSeq[seq[GridPoint]](9)
  for i in 0..<9:
    gpoints[i].setLen(9)
    for j in 0..<9:
      let pt: Position = (19.78 - 1/60 + i/60, -155.0 - 5/60 + j/60)
      gpoints[i][j] = (pt, surfaceByLongitude(pt.long))
  slices[s] = move(gpoints)

slices.mutateTimeSlices()
let routeProb = RoutingProblem(timeInterval: 10, timeFrame: slices,
                               obstacleIndices: Forbidden, startIndex: 0,
                               start: startPos, finish: endPos, allowRepeatVisits: false)
let fileName = "polar.csv"
let sp = getPolarData(fileName)
let tp = routeProb.minimumTimeRoute(sp, false)
echo "The route taking the least time found was:"
echo tp.path
echo "which has duration ", int(tp.duration / 60), " hours ", toInt(tp.duration mod 60), " minutes."
