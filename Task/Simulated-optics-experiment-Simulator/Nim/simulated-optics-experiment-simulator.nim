import std/[math, os, random, sequtils, strutils, tables]


####################################################################################################
# Vector.

# A simple implementation of Gibbs vectors, suited to our purpose.
# A vector is stored in polar form, with the angle in
# degrees between 0 (inclusive) and 360 (exclusive).
type Vector = object
  magnitude: float
  angle: float

func initVector*(magnitude, angle: float): Vector =
  Vector(magnitude: magnitude, angle: floorMod(angle, 360))

func `$`*(v: Vector): string =
  "Vector($1, $2)".format(v.magnitude, v.angle)

func fromRect*(x, y: float): Vector =
  ## Return a vector for the given rectangular coordinates.
  Vector(magnitude: hypot(x, y), angle: floorMod(arctan2(y, x).radToDeg, 360))

func toRect*(v: Vector): (float, float) =
  ## Return the x and y coordinates of the vector.
  result[0] = v.magnitude * cos(v.angle.degToRad)
  result[1] = v.magnitude * sin(v.angle.degToRad)

func `*`*(v: Vector; scalar: float): Vector =
  ## Multiply a vector by a scalar, returning a new vector.
  Vector(magnitude: v.magnitude * scalar, angle: v.angle)

func dotProduct*(u, v: Vector): float =
  ## Return the dot product of two vectors.
  u.magnitude * v.magnitude * cos(degToRad(u.angle - v.angle))

func `-`*(u, v: Vector): Vector =
  ## Return the difference of two vectors.
  let (xu, yu) = u.toRect()
  let (xv, yv) = v.toRect()
  result = fromRect(xu - xv, yu - yv)

func projection*(u, v: Vector): Vector =
  ## Return the projection of vector "u" onto vector "v".
  result = v * (dotProduct(u, v) / dotProduct(v, v))


####################################################################################################
# Channels.

type

  DataOut = Table[string, int]    # Representation of output data.

  IntChannel = ptr Channel[int]
  VectorChannel = ptr Channel[Vector]
  DataChannel = ptr Channel[DataOut]

proc newIntChannel(): IntChannel =
  cast[IntChannel](allocShared0(sizeof(Channel[int])))

proc newVectorChannel(): VectorChannel =
  cast[VectorChannel](allocShared0(sizeof(Channel[Vector])))

proc newDataChannel(): DataChannel =
  cast[DataChannel](allocShared0(sizeof(Channel[DataOut])))


####################################################################################################
# Mechanism.

# A Mechanism represents a part of the experimental apparatus.
type Mechanism = ref object of RootObj
  randState: Rand   # Random generator state (one per instance, so one per thread).
  operating: bool   # True if the mechanism is operating.

proc init(m: Mechanism) =
  ## Initialize a mechanism.
  m.randState = initRand()

method run(m: Mechanism) {.base, gcsafe.}=
  ## Virtual method to override.
  raise newException(CatchableError, "method without implementation override.")

proc start(m: Mechanism) {.thread.} =
  ## Run the mechanism.
  m.operating = true
  while m.operating:
    m.run()
    # A small pause of one ms to try not to overtax the computer.
    sleep(1)

func stop(m: Mechanism) =
  ## Stop the mechanism.
  m.operating = false


####################################################################################################
# LightSource.

# A LightSource occasionally emits oppositely plane-polarized
# light pulses, of fixed amplitude, polarized 90° with respect to
# each other. The pulses are represented by the vectors (1,0°) and
# (1,90°), respectively. One is emitted to the left, the other to
# the right. The probability is 1/2 that the (1,0°) pulse is emitted
# to the left.

# The LightSource records which pulse it emitted in which direction.
type LightSource = ref object of Mechanism
  cL: VectorChannel
  cR: VectorChannel
  cLog: IntChannel

proc newLightSource(cL, cR: VectorChannel; cLog: IntChannel): LightSource =
  ## Create a LightSource object.
  result = LightSource(cL: cL, cR: cR, cLog: cLog)
  result.init()

method run(ls: LightSource) =
  ## Emit a light pulse.
  let n = ls.randState.rand(1)
  let val = 90 * n.toFloat
  ls.cL[].send initVector(1, val)
  ls.cR[].send initVector(1, 90 - val)
  ls.cLog[].send(n)


####################################################################################################
# PolarizingBeamSplitter

# A polarizing beam splitter takes a plane-polarized light pulse
# and splits it into two plane-polarized pulses. The directions of
# polarization of the two output pulses are determined solely by the
# angular setting of the beam splitter—NOT by the angle of the
# original pulse. However, the amplitudes of the output pulses
# depend on the angular difference between the impinging light pulse
# and the beam splitter.

# Each beam splitter is designed to select randomly between one of
# two angle settings. It records which setting it selected (by
# putting that information into one of its output queues).

type PolarizingBeamSplitter = ref object of Mechanism
  cS: VectorChannel
  cS1: VectorChannel
  cS2: VectorChannel
  cLog: IntChannel
  angles: array[2, float]

proc newPolarizingBeamSplitter(cS, cS1, cS2: VectorChannel; cLog: IntChannel;
                               angles: array[2, float]): PolarizingBeamSplitter =
  ## Create a PolarizingBeamSplitter object.
  result = PolarizingBeamSplitter(cS: cS, cS1: cS1, cS2: cS2, cLog: cLog, angles: angles)
  result.init()

method run(pbs: PolarizingBeamSplitter) =
  ## Split a light pulse into two pulses. One of output pulses
  ## may be visualized as the vector projection of the input pulse
  ## onto the direction vector of the beam splitter. The other
  ## output pulse is the difference between the input pulse and the
  ## first output pulse: in other words, the orthogonal component.
  let angleSetting = pbs.randState.rand(1)
  pbs.cLog[].send(angleSetting)

  let angle = pbs.angles[angleSetting]
  assert angle >= 0 and angle < 90

  let v = pbs.cS[].recv()
  let v1 = projection(v, initVector(1, angle))
  let v2 = v - v1

  pbs.cS1[].send(v1)
  pbs.cS2[].send(v2)


####################################################################################################
# LightDetector.

# Our light detector is assumed to work as follows: if a
# uniformly distributed random number between 0 and 1 is less than
# or equal to the intensity (square of the amplitude) of an
# impinging light pulse, then the detector outputs a 1, meaning the
# pulse was detected. Otherwise it outputs a 0, representing the
# quiescent state of the detector.

type LightDetector = ref object of Mechanism
  cIn: VectorChannel
  cOut: IntChannel

proc newLightDetector(cIn: VectorChannel; cOut: IntChannel): LightDetector =
  ## Create a LightDetector object.
  result = LightDetector(cIn: cIn, cOut: cOut)
  result.init()

method run(ld: LightDetector) =
  ## When a light pulse comes in, either detect it or do not.
  let pulse = ld.cIn[].recv()
  let intensity = pulse.magnitude^2
  ld.cOut[].send ord(ld.randState.rand(1.0) <= intensity)


####################################################################################################
# DataSynchronizer.

# The data synchronizer combines the raw data from the logs and
# the detector outputs, putting them into dictionaries of
# corresponding data.

type DataSynchronizer = ref object of Mechanism
  cLogS: IntChannel
  cLogL: IntChannel
  cLogR: IntChannel
  cDetectedL1: IntChannel
  cDetectedL2: IntChannel
  cDetectedR1: IntChannel
  cDetectedR2: IntChannel
  cDataOut: DataChannel

proc newDataSynchronizer(cLogS, cLogL, cLogR, cDetectedL1, cDetectedL2,
                         cDetectedR1, cDetectedR2: IntChannel;
                         cDataOut: DataChannel): DataSynchronizer =
  ## Create a DataSynchronizer object.
  result = DataSynchronizer(cLogS: cLogs, cLogL: cLogL, cLogR: cLogR, cDetectedL1: cDetectedL1,
                            cDetectedL2: cDetectedL2, cDetectedR1: cDetectedR1,
                            cDetectedR2: cDetectedR2, cDataOut: cDataOut)

method run(ds: DataSynchronizer) =
  ## This method does the synchronizing.
  ds.cDataOut[].send DataOut {"logS": ds.cLogS[].recv(),
                              "logL": ds.cLogL[].recv(),
                              "logR": ds.cLogR[].recv(),
                              "detectedL1": ds.cDetectedL1[].recv(),
                              "detectedL2": ds.cDetectedL2[].recv(),
                              "detectedR1": ds.cDetectedR1[].recv(),
                              "detectedR2": ds.cDetectedR2[].recv()}.toTable

proc saveRawData(filename: string; data: seq[DataOut]) =

  proc saveData(f: File) =
    f.write $data.len, '\n'
    for entry in data:
      for i, key in ["logS", "logL", "logR", "detectedL1",
                     "detectedL2", "detectedR1", "detectedR2"]:
        f.write $entry[key]
        f.write if i == 6: '\n' else: ' '

  if filename != "-":
    var f = open(filename, fmWrite)
    f.saveData()
    f.close()
  else:
    stdout.saveData()


when isMainModule:

  if paramCount() notin [1, 2]:
    quit "Usage: $1 NUM_PULSES [RAW_DATA_FILE]" % getAppFilename(), QuitFailure
  let numPulses = paramStr(1).parseInt()
  let rawDataFilename = if paramCount() == 2: paramStr(2) else: "-"

  # Angles commonly used in actual experiments. Whatever angles you
  # use have to be zero degrees or placed in Quadrant 1. This
  # constraint comes with no loss of generality, because a
  # polarizing beam splitter is actually a sort of rotated
  # "X". Therefore its orientation can be specified by any one of
  # the arms of the X. Using the Quadrant 1 arm simplifies data
  # analysis.

  const AnglesL = [0.0, 45.0]
  const AnglesR = [22.5, 67.5]
  assert allIt(AnglesL, it >= 0 and it < 90) and allIt(AnglesR, it >= 0 and it < 90)

  # Channels used for communications between the threads.
  const MaxSize = 100_000
  var
    cLogS = newIntChannel()
    cLogL = newIntChannel()
    cLogR = newIntChannel()
    cL = newVectorChannel()
    cR = newVectorChannel()
    cL1 = newVectorChannel()
    cL2 = newVectorChannel()
    cR1 = newVectorChannel()
    cR2 = newVectorChannel()
    cDetectedL1 = newIntChannel()
    cDetectedL2 = newIntChannel()
    cDetectedR1 = newIntChannel()
    cDetectedR2 = newIntChannel()
    cDataOut = newDataChannel()

  # Objects that will run in the various threads.
  var
    lightSource = newLightSource(cL, cR, cLogS)
    splitterL = newPolarizingBeamSplitter(cL, cL1, cL2, cLogL, AnglesL)
    splitterR = newPolarizingBeamSplitter(cR, cR1, cR2, cLogR, AnglesR)
    detectorL1 = newLightDetector(cL1, cDetectedL1)
    detectorL2 = newLightDetector(cL2, cDetectedL2)
    detectorR1 = newLightDetector(cR1, cDetectedR1)
    detectorR2 = newLightDetector(cR2, cDetectedR2)
    sync = newDataSynchronizer(cLogS, cLogL, cLogR, cDetectedL1, cDetectedL2,
                               cDetectedR1, cDetectedR2, cDataOut)

  # Open channels.
  for c in [cLogs, cLogL, cLogR, cDetectedL1, cDetectedL2, cDetectedR1, cDetectedR2]:
    c[].open(MaxSize)
  for c in [cL, cR, cL1, cL2, cR1, cR2]:
    c[].open(MaxSize)
  cDataOut[].open(MaxSize)

  # Threads.
  var lightsourceThread,
      splitterLThread,
      splitterRThread,
      detectorL1Thread,
      detectorL2Thread,
      detectorR1Thread,
      detectorR2Thread,
      syncThread: Thread[Mechanism]

  # Start the threads.
  lightsourceThread.createThread(start, Mechanism(lightSource))
  splitterLThread.createThread(start, Mechanism(splitterL))
  splitterRThread.createThread(start, Mechanism(splitterR))
  detectorL1Thread.createThread(start, Mechanism(detectorL1))
  detectorL2Thread.createThread(start, Mechanism(detectorL2))
  detectorR1Thread.createThread(start, Mechanism(detectorR1))
  detectorR2Thread.createThread(start, Mechanism(detectorR2))
  syncThread.createThread(start, Mechanism(sync))

  var data: seq[DataOut]
  for i in 1..numPulses:
    data.add cDataOut[].recv()
  saveRawData(rawDataFilename, data)

  # Stop the apparatus.
  lightSource.stop()
  splitterL.stop()
  splitterR.stop()
  detectorL1.stop()
  detectorL2.stop()
  detectorR1.stop()
  detectorR2.stop()
  sync.stop()

  # Wait for thread terminations.
  joinThread(lightsourceThread)
  joinThread(splitterLThread)
  joinThread(splitterRThread)
  joinThread(detectorL1Thread)
  joinThread(detectorL2Thread)
  joinThread(detectorR1Thread)
  joinThread(detectorR2Thread)
  joinThread(syncThread)

  # Close the channels.
  for c in [cLogs, cLogL, cLogR, cDetectedL1, cDetectedL2, cDetectedR1, cDetectedR2]:
    c[].close()
  for c in [cL, cR, cL1, cL2, cR1, cR2]:
    c[].close()
  cDataOut[].close()
