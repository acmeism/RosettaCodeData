from mpmath import mp
heegner = [19,43,67,163]
mp.dps = 50
x = mp.exp(mp.pi*mp.sqrt(163))
print("calculated Ramanujan's constant: {}".format(x))
print("Heegner numbers yielding 'almost' integers:")
for i in heegner:
    print(" for {}: {} ~ {} error: {}".format(str(i),mp.exp(mp.pi*mp.sqrt(i)),round(mp.exp(mp.pi*mp.sqrt(i))),(mp.pi*mp.sqrt(i)) - round(mp.pi*mp.sqrt(i))))
