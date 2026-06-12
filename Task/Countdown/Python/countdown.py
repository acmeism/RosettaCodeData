best = 0
best_out = ""
target = 952
nbrs = [100, 75, 50, 25, 6, 3]

def sol(target, nbrs, out=""):
    global best, best_out
    if abs(target - best) > abs(target - nbrs[0]):
        best = nbrs[0]
        best_out = out
    if target == nbrs[0]:
        print(out)
    elif len(nbrs) > 1:
        for i1 in range(0, len(nbrs)-1):
            for i2 in range(i1+1, len(nbrs)):
                remains = nbrs[:i1] + nbrs[i1+1:i2] + nbrs[i2+1:]
                a, b = nbrs[i1], nbrs[i2]
                if a > b: a, b = b, a
                res = b + a
                op = str(b) + " + " + str(a) + " = " + str(res) + " ; "
                sol(target, [res] + remains, out + op)
                if b != a:
                    res = b - a
                    op = str(b) + " - " + str(a) + " = " + str(res) + " ; "
                    sol(target, [res] + remains, out + op)
                if a != 1:
                    res = b * a
                    op = str(b) + " * " + str(a) + " = " + str(res) + " ; "
                    sol(target, [res] + remains, out + op)
                    if b % a == 0:
                        res = int(b / a)
                        op = str(b) + " / " + str(a) + " = " + str(res) + " ; "
                        sol(target, [res] + remains, out + op)

sol(target, nbrs)
if best != target:
    print("Best solution " + str(best))
    print(best_out)
