import random

type
  IntArray = array[0..2, int]
  FloatArray = array[0..2, float]

func targetOutput(a, b: int): int =
  ## The function the perceptron will be learning is f(x) = 2x + 1.
  if a * 2 + 1 < b: 1 else: - 1

proc showTargetOutput =
  for y in countdown(10, - 9):
    for x in countup(-9, 10):
      stdout.write if targetOutput(x, y) == 1: '#' else: 'O'
    echo()
  echo()

proc randomWeights(ws: var FloatArray) =
  ## Start with random weights.
  randomize()
  for w in ws.mitems:
    w = rand(1.0) * 2 + 1

func feedForward(ins: IntArray; ws: FloatArray): int =
  ## The perceptron outputs 1 if the sum of its inputs multiplied by
  ## its input weights is positive, otherwise -1.
  var sum = 0.0
  for i in 0..ins.high:
    sum += ins[i].toFloat * ws[i]
  result = if sum > 0: 1 else: -1

proc showOutput(ws: FloatArray) =
  var inputs: IntArray
  inputs[2] = 1   # bias.
  for y in countdown(10, -9):
    inputs[1] = y
    for x in countup(-9, 10):
      inputs[0] = x
      stdout.write if feedForward(inputs, ws) == 1: '#' else: 'O'
    echo()
  echo()

proc train(ws: var FloatArray; runs: int) =
  var inputs: IntArray
  inputs[2] = 1   # bias.
  for _ in 1..runs:
    for y in countdown(10, -9):
      inputs[1] = y
      for x in countup(-9, 10):
        inputs[0] = x
        let error = targetOutput(x, y) - feedForward(inputs, ws)
        for i in 0..2:
          ws[i] += float(error * inputs[i]) * 0.01  # 0.01 is the learning constant.

when isMainModule:
  var weights: FloatArray
  echo "Target output for the function f(x) = 2x + 1:"
  showTargetOutput()
  randomWeights(weights)
  echo "Output from untrained perceptron:"
  showOutput(weights)
  train(weights, 1)
  echo "Output from perceptron after 1 training run:"
  showOutput(weights)
  train(weights, 4)
  echo "Output from perceptron after 5 training runs:"
  showOutput(weights)
