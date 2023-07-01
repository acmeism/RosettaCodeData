import algorithm
import nimPNG

type

  Channel {.pure.} = enum R, G, B

  QItem = tuple
    color: array[Channel, byte]   # Color of the pixel.
    index: int                    # Position of pixel in the sequential sequence.

#---------------------------------------------------------------------------------------------------

proc quantize(bucket: openArray[QItem]; output: var seq[byte]) =
  ## Apply the quantization to the pixels in the bucket.

  # Compute the mean value on each channel.
  var means: array[Channel, int]
  for qItem in bucket:
    for channel in R..B:
      means[channel] += qItem.color[channel].int
  for channel in R..B:
    means[channel] = (means[channel] / bucket.len).toInt

  # Store the new colors into the pixels.
  for qItem in bucket:
    for channel in R..B:
      output[3 * qItem.index + ord(channel)] = means[channel].byte

#---------------------------------------------------------------------------------------------------

proc medianCut(bucket: openArray[QItem]; depth: Natural; output: var seq[byte]) =
  ## Apply the algorithm on the bucket.

  if depth == 0:
    # Terminated for this bucket. Apply the quantization.
    quantize(bucket, output)
    return

  # Compute the range of values for each channel.
  var minVal: array[Channel, int] = [1000, 1000, 1000]
  var maxVal: array[Channel, int] = [-1, -1, -1]
  for qItem in bucket:
    for channel in R..B:
      let val = qItem.color[channel].int
      if val < minVal[channel]: minVal[channel] = val
      if val > maxVal[channel]: maxVal[channel] = val
  let valRange: array[Channel, int] = [maxVal[R] - minVal[R],
                                       maxVal[G] - minVal[G],
                                       maxVal[B] - minVal[B]]

  # Find the channel with the greatest range.
  var selchannel: Channel
  if valRange[R] >= valRange[G]:
    if valRange[R] >= valRange[B]:
      selchannel = R
    else:
      selchannel = B
  elif valrange[G] >= valrange[B]:
    selchannel = G
  else:
    selchannel = B

  # Sort the quantization items according to the selected channel.
  let sortedBucket = case selchannel
                     of R: sortedByIt(bucket, it.color[R])
                     of G: sortedByIt(bucket, it.color[G])
                     of B: sortedByIt(bucket, it.color[B])

  # Split the bucket into two buckets.
  let medianIndex = bucket.high div 2
  medianCut(sortedBucket.toOpenArray(0, medianIndex), depth - 1, output)
  medianCut(sortedBucket.toOpenArray(medianIndex, bucket.high), depth - 1, output)

#———————————————————————————————————————————————————————————————————————————————————————————————————

const Input = "Quantum_frog.png"
const Output = "Quantum_frog_16.png"

let pngImage = loadPNG24(seq[byte], Input).get()

# Build the first bucket.
var bucket = newSeq[QItem](pngImage.data.len div 3)
var idx: Natural = 0
for item in bucket.mitems:
  item = (color: [pngImage.data[idx], pngImage.data[idx + 1], pngImage.data[idx + 2]],
          index: idx div 3)
  inc idx, 3

# Create the storage for the quantized image.
var data = newSeq[byte](pngImage.data.len)

# Launch the quantization.
medianCut(bucket, 4, data)

# Save the result into a PNG file.
let status = savePNG24(Output, data, pngImage.width, pngImage.height)
if status.isOk:
  echo "File ", Input, " processed. Result is available in file ", Output
else:
  echo "Error: ", status.error
