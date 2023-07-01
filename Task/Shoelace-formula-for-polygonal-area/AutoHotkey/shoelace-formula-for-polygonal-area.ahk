V := [[3, 4], [5, 11], [12, 8], [9, 5], [5, 6]]

n := V.Count()
for i, O in V
    Sum += V[i, 1] * V[i+1, 2]  -  V[i+1, 1] * V[i, 2]
MsgBox % result := Abs(Sum += V[n, 1] * V[1, 2]  -  V[1, 1] * V[n, 2]) / 2
