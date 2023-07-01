let getMandelbrotValues width height maxIter ((xMin,xMax),(yMin,yMax)) =
  let mandIter (cr:float,ci:float) =
    let next (zr,zi) = (cr + (zr * zr - zi * zi)), (ci + (zr * zi + zi * zr))
    let rec loop = function
      | step,_ when step=maxIter->0
      | step,(zr,zi) when ((zr * zr + zi * zi) > 2.0) -> step
      | step,z -> loop ((step + 1), (next z))
    loop (0,(0.0, 0.0))
  let forPos =
    let dx, dy = (xMax - xMin) / (float width), (yMax - yMin) / (float height)
    fun y x -> mandIter ((xMin + dx * float(x)), (yMin + dy * float(y)))
  [0..height-1] |> List.map(fun y->[0..width-1] |> List.map (forPos y))
