catchphrase = "%d bottles of beer on the wall"

strofas = ("\n".join((
    catchphrase % n,
    catchphrase[:18] % n,
    "Take one down and pass it around",
    catchphrase % (n-1)
)) for n in range(99, 0, -1))

print("\n\n".join(strofas))
