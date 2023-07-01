import strutils, math, stats

func meanSquareDiff(refValue: float; estimates: seq[float]): float =
  ## Compute the mean of the squares of the differences
  ## between estimated values and a reference value.
  for estimate in estimates:
    result += (estimate - refValue)^2
  result /= estimates.len.toFloat


const Samples = [(trueValue: 49.0, estimates: @[48.0, 47.0, 51.0]),
                 (trueValue: 49.0, estimates: @[48.0, 47.0, 51.0, 42.0])]

for (trueValue, estimates, ) in Samples:
  let m = mean(estimates)
  echo "True value:           ", trueValue
  echo "Estimates:            ", estimates.join(", ")
  echo "Average error:        ", meanSquareDiff(trueValue, estimates)
  echo "Crowd error:          ", (m - trueValue)^2
  echo "Prediction diversity: ", meanSquareDiff(m, estimates)
  echo ""
