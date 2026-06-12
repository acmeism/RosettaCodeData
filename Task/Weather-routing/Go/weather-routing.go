package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "math"
    "strconv"
    "strings"
)

type matrixF = [][]float64
type pred = func(float64) bool

/*
   Structure that represents a polar CSV file's data.
   Note 0 degrees is directly into the wind, 180 degrees is directly downwind.
*/
type SailingPolar struct {
    winds   []float64 // vector of windspeeds
    degrees []float64 // vector of angles in degrees of direction relative to the wind
    speeds  matrixF   // matrix of sailing speeds indexed by wind velocity and angle of boat to wind
}

/*
   Structure that represents wind and surface current direction and velocity for a given position.
   Angles in degrees, velocities in knots.
*/
type SurfaceParameters struct{ windDeg, windKts, currentDeg, currentKts float64 }

// Checks for fatal errors.
func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

// Reads a sailing polar CSV file and returns a SailingPolar struct containing the file data.
// A sailing polar file is a CSV file, with ';' used as the comma separator instead of a comma.
// The first line of file contains labels for the wind velocities that make up columns, and
// the first entry of each row makes up a column of angle of sailing direction from wind in degrees.
func getPolarData(fileName string) *SailingPolar {
    content, err := ioutil.ReadFile(fileName)
    check(err)
    lines := strings.Split(string(content), "\n")
    line0 := strings.TrimSpace(lines[0])
    header := strings.Split(line0, ";")
    var winds, degrees []float64
    var speeds matrixF
    for _, col := range header[1:] {
        t, err := strconv.ParseFloat(col, 64)
        check(err)
        winds = append(winds, t)
    }
    for _, line := range lines[1:] {
        line = strings.TrimSpace(line)
        if line == "" {
            break // ignore final blank line if there is one
        }
        cols := strings.Split(line, ";")
        f, err := strconv.ParseFloat(cols[0], 64)
        check(err)
        degrees = append(degrees, f)
        var temp []float64
        for _, col := range cols[1:] {
            t, err := strconv.ParseFloat(col, 64)
            check(err)
            temp = append(temp, t)
        }
        speeds = append(speeds, temp)
    }
    return &SailingPolar{winds, degrees, speeds}
}

const R = 6372800.0 // Earth's approximate radius in meters

/* various helper methods which work with degrees rather than radians. */

// Converts degrees to radians.
func deg2Rad(deg float64) float64 { return math.Mod(deg*math.Pi/180+2*math.Pi, 2*math.Pi) }

// Converts radians to degrees.
func rad2Deg(rad float64) float64 { return math.Mod(rad*180/math.Pi+360, 360) }

// Trig functions.
func sind(d float64) float64     { return math.Sin(deg2Rad(d)) }
func cosd(d float64) float64     { return math.Cos(deg2Rad(d)) }
func asind(d float64) float64    { return rad2Deg(math.Asin(d)) }
func atand(x, y float64) float64 { return rad2Deg(math.Atan2(x, y)) }

// Calculates the haversine function for two points on the Earth's surface.
// Given two latitude, longitude pairs in degrees for a point on the Earth,
// get distance in meters and the initial direction of travel in degrees for
// movement from point 1 to point 2.
func haversine(lat1, lon1, lat2, lon2 float64) (float64, float64) {
    dlat := lat2 - lat1
    dlon := lon2 - lon1
    a := math.Pow(sind(dlat/2), 2) + cosd(lat1)*cosd(lat2)*math.Pow(sind(dlon/2), 2)
    c := 2 * asind(math.Sqrt(a))
    theta := atand(sind(dlon)*cosd(lat2), cosd(lat1)*sind(lat2)-sind(lat1)*cosd(lat2)*cosd(dlon))
    theta = math.Mod(theta+360, 360)
    return R * c * 0.5399565, theta
}

// Returns the index of the first element of 'a' for which 'p' returns true or -1 otherwise.
func findFirst(a []float64, p pred) int {
    for i, e := range a {
        if p(e) {
            return i
        }
    }
    return -1
}

// Returns the index of the last element of 'a' for which 'p' returns true or -1 otherwise.
func findLast(a []float64, p pred) int {
    for i := len(a) - 1; i >= 0; i-- {
        if p(a[i]) {
            return i
        }
    }
    return -1
}

// Calculate the expected sailing speed in a specified direction in knots,
// given sailing polar data, a desired point of sail in degrees, and wind speed in knots.
func boatSpeed(sp *SailingPolar, pointOfSail, windSpeed float64) float64 {
    winds := sp.winds
    degrees := sp.degrees
    speeds := sp.speeds
    udeg := findLast(degrees, func(t float64) bool { return t <= pointOfSail })
    odeg := findFirst(degrees, func(t float64) bool { return t >= pointOfSail })
    uvel := findLast(winds, func(t float64) bool { return t <= windSpeed })
    ovel := findFirst(winds, func(t float64) bool { return t >= windSpeed })
    if udeg == -1 || odeg == -1 || uvel == -1 || ovel == -1 {
        return -1
    }
    var frac float64
    switch {
    case odeg == udeg && uvel == ovel:
        frac = 1
    case odeg == udeg:
        frac = (windSpeed - winds[uvel]) / (winds[ovel] - winds[uvel])
    case uvel == ovel:
        frac = (pointOfSail - degrees[udeg]) / (degrees[odeg] - degrees[udeg])
    default:
        frac = ((pointOfSail-degrees[udeg])/(degrees[odeg]-degrees[udeg]) +
            (windSpeed-winds[uvel])/(winds[ovel]-winds[uvel])) / 2
    }
    return speeds[udeg][uvel] + frac*(speeds[odeg][ovel]-speeds[udeg][uvel])
}

// Calculates the expected net boat speed in a desired direction versus the wind ('azimuth').
// This is generally different from the actual boat speed in its actual direction.
// Directions are in degrees ('pointos' is point of sail the ship direction from the wind),
// and velocity of wind ('ws') is in knots.
func sailingSpeed(sp *SailingPolar, azimuth, pointos, ws float64) float64 {
    return boatSpeed(sp, pointos, ws) * cosd(math.Abs(pointos-azimuth))
}

// Calculates the net direction and velocity of a sailing ship.
// Arguments are sailing polar data, direction of travel in degrees from north, wind direction in
// degrees from north, wind velocity in knots, surface current direction in degrees, and
// current velocity in knots.
func bestVectorSpeed(sp *SailingPolar, dirTravel, dirWind, windSpeed, dirCur, velCur float64) (float64, float64) {
    azimuth := math.Mod(dirTravel-dirWind, 360)
    if azimuth < 0 {
        azimuth += 360
    }
    if azimuth > 180 {
        azimuth = 360 - azimuth
    }
    vmg := boatSpeed(sp, azimuth, windSpeed)
    other := -1.0
    idx := -1
    for i, d := range sp.degrees {
        ss := sailingSpeed(sp, azimuth, d, windSpeed)
        if ss > other {
            other = ss
            idx = i
        }
    }
    if other > vmg {
        azimuth = sp.degrees[idx]
        vmg = other
    }
    dirChosen := deg2Rad(dirWind + azimuth)
    wx := vmg * math.Sin(dirChosen)
    wy := vmg * math.Cos(dirChosen)
    curX := velCur * math.Sin(deg2Rad(dirCur))
    curY := velCur * math.Cos(deg2Rad(dirCur))
    return rad2Deg(math.Atan2(wy+curY, wx+curX)), math.Sqrt(math.Pow(wx+curX, 2) + math.Pow(wy+curY, 2))
}

// Calculates the trip time in minutes from (lat1, lon1) to the destination (lat2, lon2).
// Uses the data in SurfaceParameters for wind and current velocity and direction.
func sailSegmentTime(sp *SailingPolar, p SurfaceParameters, lat1, lon1, lat2, lon2 float64) float64 {
    distance, dir := haversine(lat1, lon1, lat2, lon2)
    _, vel := bestVectorSpeed(sp, dir, p.windDeg, p.windKts, p.currentDeg, p.currentKts)
    // minutes/s * m / (knots * (m/s / knot)) = minutes
    return (1.0 / 60.0) * distance / (vel * 1.94384)
}

/* Structure that represents a point in 2-D space. */
type Point2 struct{ x, y int }

func (p Point2) add(p2 Point2) Point2  { return Point2{p.x + p2.x, p.y + p2.y} }
func (p Point2) equals(p2 Point2) bool { return p.x == p2.x && p.y == p2.y }
func (p Point2) String() string        { return fmt.Sprintf("[%d, %d]", p.x, p.y) }

/*
   Structure that consists of a tuple of latitude and longitude in degrees.
   NB: This uses latitude (often considered to be y) first then longitude (often considered to be x).
   This latitude, then longitude ordering is as per ISO 6709 (en.wikipedia.org/wiki/ISO_6709).
*/
type Position struct{ lat, lon float64 }

/*  Structure that represents a Position with the SurfaceParameters of wind and current at the Position. */
type GridPoint struct {
    pt Position
    sp SurfaceParameters
}
type MatrixG = [][]*GridPoint

/*
   Type alias for a matrix of GridPoints, each Position point with their SurfaceParameters.
   A Vector of TimeSlice can give the surface characteristics for an ocean region over time.
*/
type TimeSlice = MatrixG

/* Structure that represents a routing problem. */
type RoutingProblem struct {
    timeInterval    float64     // the minutes duration for each TimeSlice
    timeFrame       []TimeSlice // a vector of sequential timeslices for the ocean region
    obstacleIndices []Point2    // the Cartesian indices in each TimeSlice for
    // obstacles, such as land or shoals, where the ship may not go
    startIndex        int    // the TimeSlice position for time of starting
    start             Point2 // starting location on grid of GridPoints
    finish            Point2 // destination / finish location on grid of GridPoints
    allowRepeatVisits bool   // whether the vessel may overlap its prior path, usually false
}

/* Structure that represents a timed path. */
type TimedPath struct {
    duration float64  // minutes total to travel the path
    path     []Point2 // vector of Cartesian indices of points in grid for path to travel
}

func (t TimedPath) String() string           { return fmt.Sprintf("%g %v", t.duration, t.path) }
func (t TimedPath) equals(t2 TimedPath) bool { return t.String() == t2.String() }

func findMin(a []float64) (float64, int) {
    min := a[0]
    idx := 0
    for i, e := range a[1:] {
        if e < min {
            min = e
            idx = i + 1
        }
    }
    return min, idx
}

var ntuples = [][2]int{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
var neighbors = make([]Point2, len(ntuples))

func init() {
    for i := 0; i < len(ntuples); i++ {
        neighbors[i] = Point2{ntuples[i][0], ntuples[i][1]}
    }
}

func contains(points []Point2, point Point2) bool {
    for _, p := range points {
        if p.equals(point) {
            return true
        }
    }
    return false
}

// Returns a list of points surrounding 'p' which are not otherwise excluded.
func surround(p Point2, mat TimeSlice, excluded []Point2) []Point2 {
    xmax := len(mat)
    ymax := len(mat[0])
    var res []Point2
    for _, x := range neighbors {
        q := x.add(p)
        if (0 <= q.x && q.x < xmax) && (0 <= q.y && q.y < ymax) && !contains(excluded, q) {
            res = append(res, q)
        }
    }
    return res
}

// Get the route (as a TimedPath) that minimizes time from start to finish for a given
// RoutingProblem (sea parameters) given sailing polar data (ship parameters).
func minimumTimeRoute(rp *RoutingProblem, sp *SailingPolar, verbose bool) *TimedPath {
    timedPaths := []*TimedPath{&TimedPath{0, []Point2{rp.start}}}
    completed := false
    minPath := &TimedPath{1000, []Point2{}}
    for i := 0; i < 1000; i++ {
        var newPaths []*TimedPath
        if verbose {
            fmt.Printf("Checking %d paths of length %d\n", len(timedPaths), len(timedPaths[0].path))
        }
        for _, tpath := range timedPaths {
            le := len(tpath.path)
            if tpath.path[le-1] == rp.finish {
                completed = true
                newPaths = append(newPaths, tpath)
            } else {
                p1 := tpath.path[le-1]
                num := int(math.Round(tpath.duration))
                den := int(math.Round(rp.timeInterval))
                slice := rp.timeFrame[(num/den)%len(rp.timeFrame)]
                for _, p2 := range surround(p1, slice, rp.obstacleIndices) {
                    if !rp.allowRepeatVisits && contains(tpath.path, p2) {
                        continue
                    }
                    gp1 := slice[p1.x][p1.y]
                    gp2 := slice[p2.x][p2.y]
                    lat1 := gp1.pt.lat
                    lon1 := gp1.pt.lon
                    lat2 := gp2.pt.lat
                    lon2 := gp2.pt.lon
                    t := sailSegmentTime(sp, gp1.sp, lat1, lon1, lat2, lon2)
                    path := make([]Point2, len(tpath.path))
                    copy(path, tpath.path)
                    path = append(path, p2)
                    newPaths = append(newPaths, &TimedPath{tpath.duration + t, path})
                }
            }
        }
        set := make(map[string]*TimedPath)
        for _, np := range newPaths {
            set[np.String()] = np
        }
        timedPaths = timedPaths[:0]
        for k := range set {
            timedPaths = append(timedPaths, set[k])
        }
        if completed {
            var durations []float64
            for _, x := range timedPaths {
                durations = append(durations, x.duration)
            }
            minDur, _ := findMin(durations)
            var finished []*TimedPath
            for _, x := range timedPaths {
                le := len(x.path)
                if x.path[le-1] == rp.finish {
                    finished = append(finished, x)
                }
            }
            durations = durations[:0]
            for _, x := range finished {
                durations = append(durations, x.duration)
            }
            minFinDur, idx := findMin(durations)
            if verbose {
                fmt.Printf("Current finished minimum: %v, others %v\n", finished[idx], minDur)
            }
            if minDur == minFinDur {
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

// These need to be changed to 0-based for Go.
var ftuples = [][2]int{
    {1, 8}, {2, 1}, {2, 8}, {3, 5}, {3, 8}, {4, 1}, {4, 5}, {4, 6}, {4, 8}, {5, 1},
    {5, 5}, {5, 6}, {5, 8}, {6, 3}, {6, 4}, {6, 5}, {6, 6}, {6, 8}, {6, 9}, {7, 1},
    {7, 4}, {7, 5}, {7, 6}, {8, 8}, {8, 9}, {9, 1}, {9, 7}, {9, 9},
}

var forbidden = make([]Point2, len(ftuples))

func init() {
    for i := 0; i < len(ftuples); i++ {
        forbidden[i] = Point2{ftuples[i][0] - 1, ftuples[i][1] - 1}
    }
}

// Create regional wind patterns on the map.
func surfaceByLongitude(lon float64) SurfaceParameters {
    switch {
    case lon < -155.03:
        return SurfaceParameters{-5, 8, 150, 0.5}
    case lon < -155.99:
        return SurfaceParameters{-90, 20, 150, 0.4}
    default:
        return SurfaceParameters{180, 25, 150, 0.3}
    }
}

// Vary wind speeds over time.
func mutateTimeSlices(slices []TimeSlice) {
    i := 1
    for _, slice := range slices {
        for j := 0; j < len(slice); j++ {
            for k := 0; k < len(slice[j]); k++ {
                x := slice[j][k]
                x.sp = SurfaceParameters{x.sp.windDeg, x.sp.windKts * (1 + 0.002*float64(i)),
                    x.sp.currentDeg, x.sp.currentKts}
            }
        }
        i++
    }
}

func main() {
    startPos := Point2{0, 3} // 0-based
    endPos := Point2{8, 3}   // ditto
    slices := make([]MatrixG, 200)
    for s := 0; s < 200; s++ {
        gpoints := make([][]*GridPoint, 9)
        for i := 0; i < 9; i++ {
            gpoints[i] = make([]*GridPoint, 9)
            for j := 0; j < 9; j++ {
                pt := Position{19.78 - 1.0/60.0 + float64(i)/60, -155.0 - 5.0/60.0 + float64(j)/60}
                gpoints[i][j] = &GridPoint{pt, surfaceByLongitude(pt.lon)}
            }
        }
        slices[s] = gpoints
    }
    mutateTimeSlices(slices)
    routeProb := &RoutingProblem{10, slices, forbidden, 0, startPos, endPos, false}
    fileName := "polar.csv"
    sp := getPolarData(fileName)
    tp := minimumTimeRoute(routeProb, sp, false)
    fmt.Println("The route taking the least time found was:\n", tp.path, "\nwhich has duration",
        int(tp.duration/60), "hours,", int(math.Round(math.Mod(tp.duration, 60))), "minutes.")
}
