let n = MathNet.Numerics.Distributions.Normal(1.0,0.5)
List.init 1000 (fun _->n.Sample())
