x = float(input("Enter any real number: "))
iters = 0
while True:
    x_new = 0.86*(x+3)
    delta = abs(x_new-x)
    iters += 1
    if delta < 10**(-15):
        print(x_new)
        print("%d iterations before convergence"%iters)
        break
    x = x_new
