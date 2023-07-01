import std/[algorithm, math, parsecsv, strformat, strutils]

const
  R = 6_371 / 1.852      # Mean radius of Earth in nautic miles.
  PlaneLat = 51.514669
  PlaneLong = 2.198581

type

  Airport = object
    name: string
    country: string
    icao: string
    latitude: float
    longitude: float  # In radians.
    altitude: float   # In radians.

func distance(𝜑₁, λ₁, 𝜑₂, λ₂: float): float =
  ## Return the distance computed using the Haversine formula.
  ## Angles are in radians. The result is expressed in nautic miles.
  let a = sin((𝜑₂ - 𝜑₁) * 0.5)^2 + cos(𝜑₁) * cos(𝜑₂) * sin((λ₂ - λ₁) * 0.5)^2
  let c = 2 * arctan2(sqrt(a), sqrt(1 - a))
  result = R * c

func bearing(𝜑₁, λ₁, 𝜑₂, λ₂: float): float =
  ## Return the bearing.
  ## Angles are in radians. The result is expressed in degrees in range [0..360[.
  let Δλ = λ₂ - λ₁
  result = arctan2(sin(Δλ) * cos(𝜑₂), cos(𝜑₁) * sin(𝜑₂) - sin(𝜑₁) * cos(𝜑₂) * cos(Δλ))
  result = (result.radToDeg + 360) mod 360

# Parse the "airports.dat" file.
var parser: CsvParser
var airports: seq[Airport]
parser.open("airports.dat")
while parser.readRow():
  assert parser.row.len == 14
  airports.add Airport(name: parser.row[1],
                       country: parser.row[3],
                       icao: parser.row[5],
                       latitude: parser.row[6].parseFloat().degToRad,
                       longitude: parser.row[7].parseFloat().degToRad)

# Compute the distances then sort them keeping the airport index.
type Distances = tuple[value: float; index: int]
var distances : seq[Distances]
let 𝜑₁ = PlaneLat.degToRad
let λ₁ = PlaneLong.degToRad
for i, airport in airports:
  distances.add (distance(𝜑₁, λ₁, airport.latitude, airport.longitude), i)
distances.sort(Ascending)

# Display the result for the 20 nearest airports.
echo &"""{"Airport":<40}{"Country":<20}{"ICAO":<9}{"Distance":<9}{"Bearing":>9}"""
echo repeat("─", 88)
for i in 0..19:
  let (d, idx) = distances[i]
  let ap = airports[idx]
  let b = bearing(𝜑₁, λ₁, ap.latitude, ap.longitude)
  echo &"{ap.name:<40}{ap.country:<20}{ap.icao:<11}{d:4.1f}{b.toInt:10}"
