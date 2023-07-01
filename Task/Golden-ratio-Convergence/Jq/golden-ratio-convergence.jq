def phi: (1 + (5|sqrt)) / 2;

# epsilon > 0
def phi($epsilon):
  { phi: 1, oldPhi: (1+$epsilon), iters:0}
  | until( (.phi - .oldPhi) | length < $epsilon;
      .oldPhi = .phi
      | .phi = 1 + (1 / .oldPhi)
      | .iters += 1 )

  | "Final value of phi : \(.phi) vs \(phi)",
    "Number of iterations : \(.iters)",
    "Absolute error (approx) : \((.phi - phi) | length)";

phi(1e-5)
