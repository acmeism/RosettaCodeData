import std/[hashes, math, os, sequtils, sets, strscans, strformat, strutils, sugar]

type
  PulseData = ref object
    logS: int
    logL: int
    logR: int
    detectedL1: int
    detectedL2: int
    detectedR1: int
    detectedR2: int
  PulseDataSet = HashSet[PulseData]


proc hash(pd: PulseData): Hash =
  ## Hash value of a PulseData object (needed for HashSet).
  hash(cast[int](pd[].addr))


func swapLRChannels(pd: PulseData) =
  ## Swap channels on both right and left. This is done if the
  ## light source was (1,90°) instead of (1,0°). For in that case
  ## the orientations of the polarizing beam splitters, relative to
  ## the light source, is different by 90°.
  swap pd.detectedL1, pd.detectedL2
  swap pd.detectedR1, pd.detectedR2


proc split(data: PulseDataSet; predicate: proc(pd: PulseData): bool): tuple[a, b: PulseDataSet] =
  ## Split the data into two subsets, according to whether a set
  ## item satisfies a predicate. The return value is a tuple, with
  ## those items satisfying the predicate in the first tuple entry, the
  ## other items in the second entry.

  let subset1 = collect:
                  for x in data:
                    if predicate(x): {x}
  let subset2 = data - subset1
  result = (subset1, subset2)


proc adjustForLightPulseOrientation(data: PulseDataSet): PulseDataSet =
  ## Some data items are for a (1,0°) light pulse. The others are
  ## for a (1,90°) light pulse. Thus the light pulses are oriented
  ## differently with respect to the polarizing beam splitters. We
  ## adjust for that distinction here.
  let (data0, data90) = data.split(proc(pd: PulseData): bool = pd.logS == 0)
  for item in data90:
    item.swapLRChannels()
  result = union(data0, data90)


proc splitAccordingToPbsSetting(data: PulseDataSet): tuple[a, b, c, d: PulseDataSet] =
  ## Split the data into four subsets: one subset for each
  ## arrangement of the two polarizing beam splitters.
  let (dataL1, dataL2) = data.split(proc(pd: PulseData): bool = pd.logL == 0)
  let (dataL1R1, dataL1R2) = dataL1.split(proc(pd: PulseData): bool = pd.logR == 0)
  let (dataL2R1, dataL2R2) = dataL2.split(proc(pd: PulseData): bool = pd.logR == 0)
  result = (dataL1R1, dataL1R2, dataL2R1, dataL2R2)


func computeCorrelationCoefficient(data: PulseDataSet; angleL, angleR: float): float =
    ## Compute the correlation coefficient for the subset of the data that
    ## corresponding to a particular setting of the polarizing beam splitters.

    # We make certain the orientations of beam splitters are
    # represented by perpendicular angles in the first and fourth
    # quadrant. This restriction causes no loss of generality, because
    # the orientation of the beam splitter is actually a rotated "X".
    assert angleL >= 0 and angleL < 90 and angleR >= 0 and angleR < 90
    #perpendicularL = angleL - 90 # In Quadrant 4.
    #perpendicularR = angleR - 90 # In Quadrant 4.

    # Note that the sine is non-negative in Quadrant 1, and the cosine
    # is non-negative in Quadrant 4. Thus we can use the following
    # estimates for cosine and sine. This is Equation (2.4) in the
    # reference. (Note, one can also use Quadrants 1 and 2 and reverse
    # the roles of cosine and sine. And so on like that.)
    let n = data.len
    var nL1, nL2, nR1, nR2 = 0
    for item in data:
      inc nL1, item.detectedL1
      inc nL2, item.detectedL2
      inc nR1, item.detectedR1
      inc nR2, item.detectedR2
    let sinL = sqrt(nL1 / n)
    let cosL = sqrt(nL2 / n)
    let sinR = sqrt(nR1 / n)
    let cosR = sqrt(nR2 / n)

    # Now we can apply the reference's Equation (2.3).
    let cosLR = (cosR * cosL) + (sinR * sinL)
    let sinLR = (sinR * cosL) - (cosR * sinL)

    # And then Equation (2.5).
    result = (cosLR * cosLR) - (sinLR * sinLR)


proc readRawData(filename: string): PulseDataSet =
  ## Read the raw data. Its order does not actually matter, so we
  ## return the data as a HashSet.

  func makeRecord(line: string): PulseData =
    new(result)
    discard line.scanf("$i $i $i $i $i $i $i", result.logS, result.logL, result.logR,
                       result.detectedL1, result.detectedL2, result.detectedR1, result.detectedR2)

  proc readData(f: File): PulseDataSet =
    let numPulses = f.readline().parseInt()
    for i in 1..numPulses:
      result.incl f.readLine().makeRecord()

  if filename != "-":
    let f = open(filename, fmRead)
    result = f.readData()
    f.close()
  else:
    result = stdin.readData()


when isMainModule:

  if paramCount() notin [0, 1]:
    quit &"Usage: {getAppFilename()} [RAW_DATA_FILE]", QuitFailure

  let rawDataFilename = if paramCount() == 1: paramStr(1) else: "-"

  # Polarizing beam splitter orientations commonly used in actual
  # experiments. These must match the values used in the simulation
  # itself. They are by design all either zero degrees or in the
  # first quadrant.
  const AnglesL = [0.0, 45.0]
  const AnglesR = [22.5, 67.5]
  assert allIt(AnglesL, it >= 0 and it < 90) and allIt(AnglesR, it >= 0 and it < 90)

  var data = readRawData(rawDataFilename)
  data = adjustForLightPulseOrientation(data)
  let (dataL1R1, dataL1R2, dataL2R1, dataL2R2) = data.splitAccordingToPbsSetting()

  let
    kappaL1R1 = dataL1R1.computeCorrelationCoefficient(AnglesL[0], AnglesR[0])
    kappaL1R2 = dataL1R2.computeCorrelationCoefficient(AnglesL[0], AnglesR[1])
    kappaL2R1 = dataL2R1.computeCorrelationCoefficient(AnglesL[1], AnglesR[0])
    kappaL2R2 = dataL2R2.computeCorrelationCoefficient(AnglesL[1], AnglesR[1])

  let chshContrast = -kappaL1R1 + kappaL1R2 + kappaL2R1 + kappaL2R2

# The nominal value of the CHSH contrast for the chosen polarizer
# orientations is 2*sqrt(2).
let chshContrastNominal = 2 * sqrt(2.0)

echo()
echo &"   light pulse events   {data.len:9}"
echo()
echo "    correlation coefs"
echo &"          {AnglesL[0]:4.1f}° {AnglesR[0]:4.1f}°   {kappaL1R1:+9.6f}"
echo &"          {AnglesL[0]:4.1f}° {AnglesR[1]:4.1f}°   {kappaL1R2:+9.6f}"
echo &"          {AnglesL[1]:4.1f}° {AnglesR[0]:4.1f}°   {kappaL2R1:+9.6f}"
echo &"          {AnglesL[1]:4.1f}° {AnglesR[1]:4.1f}°   {kappaL2R2:+9.6f}"
echo()
echo &"        CHSH contrast   {chshContrast:+9.6f}"
echo &"  2*sqrt(2) = nominal   {chshContrastNominal:+9.6f}"
echo &"           difference   {chshContrast - chshContrastNominal:+9.6f}"

# A "CHSH violation" occurs if the CHSH contrast is >2.
# https://en.wikipedia.org/w/index.php?title=CHSH_inequality&oldid=1142431418
echo()
echo &"       CHSH violation   {chshContrast - 2:+9.6f}"
echo()
