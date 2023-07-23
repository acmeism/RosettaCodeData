print(
'\n'.join(
    ''.join(
        ' *'[(z:=0, c:=x/50+y/50j, [z:=z*z+c for _ in range(99)], abs(z))[-1]<2]
        for x in range(-100,25)
    )
    for y in range(-50,50)
))
