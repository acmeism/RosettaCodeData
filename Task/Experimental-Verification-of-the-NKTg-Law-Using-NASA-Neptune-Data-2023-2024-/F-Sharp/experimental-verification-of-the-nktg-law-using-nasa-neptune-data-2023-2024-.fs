//Experimental Verification of the NKTg Law Using NASA Neptune Data (2023–2024). Nigel Galloway: February 24th., 2026
let ComputeNKTg dm_dt x v m =
  let p=nktg x v m dm_dt
  let nktg=sqrt(p.nktg1*p.nktg1+p.nktg2*p.nktg2)
  printfn "--------------------------------------------"
  printfn $"Position (x): {x}"
  printfn $"Velocity (v): {v}"
  printfn $"Mass (m): {m}"
  printfn $"Momentum (p = m * v): {p.p}"
  printfn $"NKTg1 = x * p: {p.nktg1}"
  printfn $"NKTg2 = dm_dt * p: {p.nktg2}"
  printfn $"Total NKTg: {nktg}"
let nktgNep=ComputeNKTg -0.00002000
printfn "============================================"
printfn "NKTg Law - Neptune 2023 NASA Data"
printfn "============================================"
[(4498396440.0, 5.43, 1.02430000e26);(4503443661.0, 5.43, 1.02429980e26);(4553946490.0, 5.43, 1.02429960e26);
 (4503443661.0, 5.43, 1.02429940e26);(4498396440.0, 5.43, 1.02429920e26)]|>List.iter(fun(x,v,m)->nktgNep x v m)
printfn "============================================"
printfn "NKTg Law - Neptune 2024 Simulation"
printfn "============================================"
[(4498396440.0, 5.43, 1.02429900e26);(4503443661.0, 5.43, 1.02429880e26);(4553946490.0, 5.43, 1.02429860e26);
 (4503443661.0, 5.43, 1.02429840e26);(4498396440.0, 5.43, 1.02429820e26)]|>List.iter(fun(x,v,m)->nktgNep x v m)
printfn "============================================"
printfn "Experiment Completed"
printfn "============================================"
