import math

oldPhi = 1.0
phi = 1.0
iters = 0
limit = 1e-5
while True:
    phi = 1.0 + 1.0 / oldPhi
    iters += 1
    if math.fabs(phi - oldPhi) <= limit: break
    oldPhi = phi

print(f'Final value of phi : {phi:16.14f}')
actualPhi = (1.0 + math.sqrt(5.0)) / 2.0
print(f'Number of iterations : {iters}')
print(f'Error (approx) : {phi - actualPhi:16.14f}')
