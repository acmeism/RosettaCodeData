import "io" for File

/*
    Class that represents a polar CSV file's data.
    Contains a matrix, 'speeds', of sailing speeds indexed by wind velocity and angle of boat to wind.
    'winds' is a list of wind speeds.
    'degrees' is a list of angles in degrees of direction relative to the wind.
    Note 0 degrees is directly into the wind, 180 degrees is directly downwind.
*/
class SailingPolar {
    construct new(winds, degrees, speeds) {
        _winds = winds
        _degrees = degrees
        _speeds = speeds // speeds[wind direction degrees, windspeed knots]
    }
    winds { _winds }
    degrees { _degrees }
    speeds {_speeds }
}

/*
    Class that represents wind and surface current direction and velocity for a given position.
    Angles in degrees, velocities in knots.
*/
class SurfaceParameters {
    construct new(windDeg, windKts, currentDeg, currentKts) {
        _windDeg = windDeg
        _windKts = windKts
        _currentDeg = currentDeg
        _currentKts = currentKts
    }
    windDeg { _windDeg }
    windKts { _windKts }
    currentDeg { _currentDeg }
    currentKts { _currentKts }
}

// Reads a sailing polar CSV file and returns a SailingPolar object containing the file data.
// A sailing polar file is a CSV file, with ';' used as the comma separator instead of a comma.
// The first line of file contains labels for the wind velocities that make up columns, and
// the first entry of each row makes up a column of angle of sailing direction from wind in degrees.
var getPolarData = Fn.new { |fileName|
    var lines = File.read(fileName).split("\n")
    var header = lines[0].trim().split(";")
    var winds = header[1..-1].map { |x| Num.fromString(x) }.toList
    var degrees = []
    var speeds = []
    for (line in lines[1..-1]) {
        line = line.trim()
        if (line == "") break // ignore final blank line if there is one
        var cols = line.split(";")
        degrees.add(Num.fromString(cols[0]))
        speeds.add(cols[1..-1].map{ |x| Num.fromString(x) }.toList)
    }
    return SailingPolar.new(winds, degrees, speeds)
}

var R = 6372800  // Earth's approximate radius in meters

/*  Class containing various helper methods which work with degrees rather than radians. */
class D {
    // Converts degrees to radians.
    static deg2Rad(deg) { (deg*Num.pi/180 + 2*Num.pi) % (2*Num.pi) }

    // Converts radians to degrees.
    static rad2Deg(rad) { (rad*180/Num.pi + 360) % 360 }

    // Trig functions.
    static sin(d) { deg2Rad(d).sin }
    static cos(d) { deg2Rad(d).cos }
    static asin(d) { rad2Deg(d.asin) }
    static atan(x, y) { rad2Deg(x.atan(y)) }
}

// Calculates the haversine function for two points on the Earth's surface.
// Given two latitude, longitude pairs in degrees for a point on the Earth,
// get distance in meters and the initial direction of travel in degrees for
// movement from point 1 to point 2.
var haversine = Fn.new { |lat1, lon1, lat2, lon2|
    var dlat = lat2 - lat1
    var dlon = lon2 - lon1
    var a = D.sin(dlat/2).pow(2) + D.cos(lat1) * D.cos(lat2) * (D.sin(dlon/2).pow(2))
    var c = 2 * D.asin(a.sqrt)
    var theta = D.atan(D.sin(dlon) * D.cos(lat2),
          D.cos(lat1)*D.sin(lat2) - D.sin(lat1) * D.cos(lat2) * D.cos(dlon))
    theta = (theta + 360) % 360
    return [R * c * 0.5399565, theta]
}

// Returns the index of the first element of 'a' for which 'pred' returns true or -1 otherwise.
var findFirst = Fn.new { |a, pred|
    for (i in 0...a.count) if (pred.call(a[i])) return i
    return -1
}

// Returns the index of the last element of 'a' for which 'pred' returns true or -1 otherwise.
var findLast = Fn.new { |a, pred|
    for (i in a.count-1..0) if (pred.call(a[i])) return i
    return -1
}

// Calculate the expected sailing speed in a specified direction in knots,
// given sailing polar data, a desired point of sail in degrees, and wind speed in knots.
var boatSpeed = Fn.new { |sp, pointOfSail, windSpeed|
    var winds = sp.winds
    var degrees = sp.degrees
    var speeds = sp.speeds
    var udeg = findLast.call(degrees)  { |t| t <= pointOfSail }
    var odeg = findFirst.call(degrees) { |t| t >= pointOfSail }
    var uvel = findLast.call(winds)    { |t| t <= windSpeed }
    var ovel = findFirst.call(winds)   { |t| t >= windSpeed }
    if ([udeg, odeg, uvel, ovel].any { |t| t == -1 }) return -1
    var frac = (odeg == udeg && uvel == ovel) ? 1 :
               (odeg == udeg) ? (windSpeed - winds[uvel])/(winds[ovel] - winds[uvel]) :
               (uvel == ovel) ? (pointOfSail - degrees[udeg])/(degrees[odeg] - degrees[udeg]) :
               ((pointOfSail - degrees[udeg])/(degrees[odeg] - degrees[udeg]) +
               (windSpeed - winds[uvel])/(winds[ovel] - winds[uvel]))/2
    return speeds[udeg][uvel] + frac * (speeds[odeg][ovel] - speeds[udeg][uvel])
}

// Calculates the expected net boat speed in a desired direction versus the wind ('azimuth').
// This is generally different from the actual boat speed in its actual direction.
// Directions are in degrees ('pointos' is point of sail the ship direction from the wind),
// and velocity of wind ('ws') is in knots.
var sailingSpeed = Fn.new { |sp, azimuth, pointos, ws|
    return boatSpeed.call(sp, pointos, ws) * D.cos((pointos - azimuth).abs)
}

// Calculates the net direction and velocity of a sailing ship.
// Arguments are sailing polar data, direction of travel in degrees from north, wind direction in
// degrees from north, wind velocity in knots, surface current direction in degrees, and
// current velocity in knots.
var bestVectorSpeed = Fn.new { |sp, dirTravel, dirWind, windSpeed, dirCur, velCur|
    var azimuth = (dirTravel - dirWind) % 360
    azimuth = (azimuth < 0) ? azimuth + 360 : azimuth
    azimuth = (azimuth > 180) ? 360 - azimuth : azimuth
    var VMG = boatSpeed.call(sp, azimuth, windSpeed)
    var other = -1
    var idx = -1
    for (i in 0...sp.degrees.count) {
        var ss = sailingSpeed.call(sp, azimuth, sp.degrees[i], windSpeed)
        if (ss > other) {
             other = ss
             idx = i
        }
    }
    if (other > VMG) {
        azimuth = sp.degrees[idx]
        VMG = other
    }
    var dirChosen = D.deg2Rad(dirWind + azimuth)
    var wx = VMG * (dirChosen.sin)
    var wy = VMG * (dirChosen.cos)
    var curX = velCur * (D.deg2Rad(dirCur).sin)
    var curY = velCur * (D.deg2Rad(dirCur).cos)
    return [D.rad2Deg((wy + curY).atan(wx + curX)), ((wx + curX).pow(2) + (wy + curY).pow(2)).sqrt]
}

// Calculates the trip time in minutes from (lat1, lon1) to the destination (lat2, lon2).
// Uses the data in SurfaceParameters for wind and current velocity and direction.
var sailSegmentTime = Fn.new { |sp, p, lat1, lon1, lat2, lon2|
    var h = haversine.call(lat1, lon1, lat2, lon2)
    var distance = h[0]
    var dir = h[1]
    var vel = bestVectorSpeed.call(sp, dir, p.windDeg, p.windKts, p.currentDeg, p.currentKts)[1]
    // minutes/s * m / (knots * (m/s / knot)) = minutes
    return (1 / 60) * distance / (vel * 1.94384)
}

/* Class that represents a point in 2-D space. Need value type semantics for comparisons etc. */
class Point2 {
    construct new(x, y) {
        _x = x
        _y = y
    }
    x { _x }
    y { _y }

    + (other) { Point2.new(x + other.x, y + other.y) }

    == (other) { x == other.x && y == other.y }
    != (other) { !(this == other) }

    toString { "[%(_x), %(_y)]" }
}

/*
    Class that consists of a tuple of latitude and longitude in degrees.
    NB: This uses latitude (often considered to be y) first then longitude (often considered to be x).
    This latitude, then longitude ordering is as per ISO 6709 (en.wikipedia.org/wiki/ISO_6709).
*/
class Position {
    construct new(lat, lon) {
        _lat = lat
        _lon = lon
    }
    lat { _lat }
    lon { _lon }
}

/*  Class that represents a Position with the SurfaceParameters of wind and current at the Position. */
class GridPoint {
    construct new(pt, sp) {
        _pt = pt
        _sp = sp
    }
    pt { _pt }
    pt=(value) { _pt = value }
    sp { _sp }
    sp=(value) { _sp = value }
}

/*
    Class that consists of a matrix of GridPoints, each Position point with their SurfaceParameters.
    A Vector of TimeSlice can give the surface characteristics for an ocean region over time.
*/
class TimeSlice {
    construct new(gridPoints) {
      _gridPoints = gridpoints
    }
    gridPoints { _gridPoints }
}

/*
    Class that represents a routing problem and requiring the following parameters:
    * timeinterval: the minutes duration for each TimeSlice
    * timeframe: a vector of sequential timeslices for the ocean region
    * obstacleindices: the Cartesian indices in each timeslice for
        obstacles, such as land or shoals, where the ship may not go
    * startindex: the timeslice position for time of starting
    * start: starting location on grid of GridPoints
    * finish: destination / finish location on grid of GridPoints
    * allowrepeatvisits: whether the vessel may overlap its prior path, usually false.
*/
class RoutingProblem {
    construct new(timeInterval, timeFrame, obstacleIndices, startIndex, start, finish, allowRepeatVisits) {
        _timeInterval = timeInterval // minutes between timeFrame slices
        _timeFrame = timeFrame
        _obstacleIndices = obstacleIndices
        _startIndex = startIndex
        _start = start
        _finish = finish
        _allowRepeatVisits = allowRepeatVisits
    }

    timeInterval { _timeInterval }
    timeFrame  { _timeFrame }
    obstacleIndices { _obstacleIndices }
    startIndex { _startIndex }
    start { _start }
    finish { _finish }
    allowRepeatVisits { _allowRepeatVisits }
}

/*
    Class that represents a timed path and requires the following parameters:
    * duration: minutes total to travel the path
    * path: vector of Cartesian indices of points in grid for path to travel.
*/
class TimedPath {
    construct new(duration, path) {
        _duration = duration
        _path = path
    }
    duration { _duration }
    path { _path }

    toString { "%(_duration) %(_path)" }

    == (other) { this.toString == other.toString }
    != (other) { this.toString != other.toString }
}

var findMin = Fn.new { |a|
    var min = a[0]
    var idx = 0
    for (i in 1...a.count) {
        if (a[i] < min) {
            min = a[i]
            idx = i
        }
    }
    return [min, idx]
}

var ntuples = [ [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1] ]
var neighbors = List.filled(ntuples.count, null)
(0...ntuples.count).each { |i| neighbors[i] = Point2.new(ntuples[i][0], ntuples[i][1]) }

// Returns a list of points surrounding 'p' which are not otherwise excluded.
var surround = Fn.new { |p, mat, excluded|
    var xmax = mat.count
    var ymax = mat[0].count
    return neighbors.map { |x| x + p }.where { |q|
        return (0 <= q.x && q.x < xmax) && (0 <= q.y && q.y < ymax) && !excluded.contains(q)
    }.toList
}

// Get the route (as a TimedPath) that minimizes time from start to finish for a given
// RoutingProblem (sea parameters) given sailing polar data (ship parameters).
var minimumTimeRoute = Fn.new { |rp, sp, verbose|
    var timedPaths = [TimedPath.new(0, [rp.start])]
    var completed = false
    var minPath = TimedPath.new(1000, [])
    for (i in 0...1000) {
        var newPaths = []
        verbose && System.print("Checking %(timedPaths.count) paths of length %(timedPaths[0].path.count)")
        for (tpath in timedPaths) {
            if (tpath.path[-1] == rp.finish) {
                completed = true
                newPaths.add(tpath)
            } else {
                var p1 = tpath.path[-1]
                var num = tpath.duration.round
                var den = rp.timeInterval.round
                var slice = rp.timeFrame[(num/den).truncate % rp.timeFrame.count]
                for (p2 in surround.call(p1, slice, rp.obstacleIndices)) {
                    if (rp.allowRepeatVisits || !tpath.path.contains(p2)) {
                        var gp1 = slice[p1.x][p1.y]
                        var gp2 = slice[p2.x][p2.y]
                        var lat1 = gp1.pt.lat
                        var lon1 = gp1.pt.lon
                        var lat2 = gp2.pt.lat
                        var lon2 = gp2.pt.lon
                        var t = sailSegmentTime.call(sp, gp1.sp, lat1, lon1, lat2, lon2)
                        var path = tpath.path.toList
                        path.add(p2)
                        newPaths.add(TimedPath.new(tpath.duration + t, path))
                    }
                }
            }
        }
        var set = {}
        for (np in newPaths) set[np.toString] = np
        timedPaths = set.values.toList
        if (completed) {
            var minDur = findMin.call(timedPaths.map { |x| x.duration }.toList)[0]
            var finished = timedPaths.where { |x| x.path[-1] == rp.finish }.toList
            var mi = findMin.call(finished.map { |x| x.duration }.toList)
            var minFinDur = mi[0]
            var idx = mi[1]
            if (verbose) {
                System.print("Current finished minimum: %(finished[idx]), others %(minDur)")
            }
            if (minDur == minFinDur) {
                minPath = finished[idx]
                break
            }
        }
    }
    return minPath
}

/*
    The data is selected so the best time path is slightly longer than the
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
*/

// These need to be changed to 0-based for Wren.
var ftuples = [
    [1, 8], [2, 1], [2, 8], [3, 5], [3, 8], [4, 1], [4, 5], [4, 6], [4, 8], [5, 1],
    [5, 5], [5, 6], [5, 8], [6, 3], [6, 4], [6, 5], [6, 6], [6, 8], [6, 9], [7, 1],
    [7, 4], [7, 5], [7, 6], [8, 8], [8, 9], [9, 1], [9, 7], [9, 9]
]

var forbidden = List.filled(ftuples.count, null)
(0...ftuples.count).each { |i| forbidden[i] = Point2.new(ftuples[i][0]-1, ftuples[i][1]-1) }

// Create regional wind patterns on the map.
var surfaceByLongitude = Fn.new { |lon|
    return (lon < -155.03) ? SurfaceParameters.new(-5, 8, 150, 0.5) :
           (lon < -155.99) ? SurfaceParameters.new(-90, 20, 150, 0.4) :
                             SurfaceParameters.new(180, 25, 150, 0.3)
}

// Vary wind speeds over time.
var mutateTimeSlices = Fn.new { |slices|
    var i = 1
    for (slice in slices) {
        for (j in 0...slice.count) {
            for (k in 0...slice[j].count) {
                var x = slice[j][k]
                x.sp = SurfaceParameters.new(x.sp.windDeg, x.sp.windKts * (1 + 0.002 * i),
                    x.sp.currentDeg, x.sp.currentKts)
             }
        }
        i = i + 1
    }
}

var startPos = Point2.new(0, 3)  // 0-based
var endPos = Point2.new(8, 3)    // ditto
var slices = List.filled(200, null)
for (s in 0...200) {
    var gpoints = List.filled(9, null)
    for (i in 0..8) {
        gpoints[i] = List.filled(9, null)
        for (j in 0..8) {
            var pt = Position.new(19.78 - 1/60 + i/60, -155.0 - 5/60 + j/60)
            gpoints[i][j] = GridPoint.new(pt, surfaceByLongitude.call(pt.lon))
        }
    }
    slices[s] = gpoints
}
mutateTimeSlices.call(slices)
var routeProb = RoutingProblem.new(10, slices, forbidden, 0, startPos, endPos, false)
var fileName = "polar.csv"
var sp = getPolarData.call(fileName)
var tp = minimumTimeRoute.call(routeProb, sp, false)
System.print("The route taking the least time found was:\n    %(tp.path) \nwhich has duration " +
   "%((tp.duration/60).truncate) hours, %((tp.duration%60).round) minutes.")
