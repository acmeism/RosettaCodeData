import math, os, strformat, strscans, strutils

type Vector = tuple[x, y, z: float]

func`+`(v1, v2: Vector): Vector = (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)

func `+=`(v1: var Vector; v2: Vector) =
  v1.x += v2.x
  v1.y += v2.y
  v1.z += v2.z

func`-`(v1, v2: Vector): Vector = (v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)

func `*`(v: Vector; m: float): Vector = (v.x * m, v.y * m, v.z * m)

func abs(v: Vector): float = sqrt(v.x * v.x + v.y * v.y + v.z * v.z)


type Simulation = object
  bodies: int
  timeSteps: int
  masses: seq[float]
  gc: float
  positions: seq[Vector]
  velocities: seq[Vector]
  accelerations: seq[Vector]

proc emitError(linenum: Positive) =
  raise newException(ValueError, "wrong data at line $#.".format(linenum))

proc initSimulation(fileName: string): Simulation =
  let infile = fileName.open()
  var line = infile.readLine()
  if not line.scanf("$f $i $i", result.gc, result.bodies, result.timeSteps):
    emitError(1)
  result.masses.setlen(result.bodies)
  result.positions.setLen(result.bodies)
  result.velocities.setLen(result.bodies)
  result.accelerations.setLen(result.bodies)
  var linenum = 1
  for i in 0..<result.bodies:
    inc linenum
    line = infile.readLine()
    if not line.scanf("$f", result.masses[i]):
      emitError(linenum)
    inc linenum
    line = infile.readLine()
    if not line.scanf("$f $f $f", result.positions[i].x, result.positions[i].y, result.positions[i].z):
      emitError(linenum)
    inc linenum
    line = infile.readLine()
    if not line.scanf("$f $f $f", result.velocities[i].x, result.velocities[i].y, result.velocities[i].z):
      emitError(linenum)


func resolveCollisions(sim: var Simulation) =
  for i in 0..sim.bodies-2:
    for j in i+1..sim.bodies-1:
      if sim.positions[i] == sim.positions[j]:
        swap sim.velocities[i], sim.velocities[j]


func computeAccelerations(sim: var Simulation) =
  for i in 0..<sim.bodies:
    sim.accelerations[i] = (0.0, 0.0, 0.0)
    for j in 0..<sim.bodies:
      if i != j:
          let m = sim.gc * sim.masses[j] / abs(sim.positions[i] - sim.positions[j])^3
          sim.accelerations[i] += (sim.positions[j] - sim.positions[i]) * m


func computeVelocities(sim: var Simulation) =
  for i in 0..<sim.bodies:
    sim.velocities[i] += sim.accelerations[i]


func computePositions(sim: var Simulation) =
  for i in 0..<sim.bodies:
    sim.positions[i] += sim.velocities[i] + sim.accelerations[i] * 0.5


func step(sim: var Simulation) =
  sim.computeAccelerations()
  sim.computePositions()
  sim.computeVelocities()
  sim.resolveCollisions()


proc printResults(sim: Simulation) =
  for i in 0..<sim.bodies:
    echo &"Body {i + 1}: ",
         &"{sim.positions[i].x: 8.6f}  {sim.positions[i].y: 8.6f}  {sim.positions[i].z: 8.6f} | ",
         &"{sim.velocities[i].x: 8.6f}  {sim.velocities[i].y: 8.6f}  {sim.velocities[i].z: 8.6f}"

if paramCount() != 1:
  echo "Usage: $# <file name containing system configuration data>" % getAppFilename().lastPathPart
else:
  var sim = initSimulation(paramStr(1))
  echo "Body         x          y          z    |     vx         vy         vz"
  for step in 1..sim.timeSteps:
    echo "\nCycle ", step
    sim.step()
    sim.printResults()
