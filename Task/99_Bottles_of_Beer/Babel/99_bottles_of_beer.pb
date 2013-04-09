main: { 99 bottles }

bottles!:
    { x set
        { bw
        bx cr <<
        "Take one down, pass it around\n" <<
        1 x -=
        bw "\n" << }
    x times }

b  : " bottles of beer"
bx!: { x %d << b }
w  : " on the wall"
bw!: { bx w . cr << }

x: [0]
