let getJuliaValues width height centerX centerY zoom maxIter =
  let initzx x = 1.5 * float(x - width/2) / (0.5 * zoom * float(width))
  let initzy y = 1.0 * float(y - height/2) / (0.5 * zoom * float(height))
  let calc y x =
    let rec loop i zx zy =
      if i=maxIter then 0
      elif zx*zx + zy*zy >= 4.0 then i
      else loop (i + 1) (zx*zx - zy*zy + centerX) (2.0*zx*zy + centerY)
    loop 0 (initzx x) (initzy y)
  [0..height-1] |> List.map(fun y->[0..width-1] |> List.map (calc y))
