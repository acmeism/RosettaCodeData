import "./fmt" for Fmt

var oldPhi = 1
var phi
var iters = 0
var limit = 1e-5
while (true) {
    phi = 1 + 1 / oldPhi
    iters = iters + 1
    if ((phi - oldPhi).abs <= limit) break
    oldPhi = phi
}
Fmt.print("Final value of phi : $16.14f", phi)
var actualPhi = (1 + 5.sqrt) / 2
Fmt.print("Number of iterations : $d", iters)
Fmt.print("Error (approx) : $16.14f", phi - actualPhi)
