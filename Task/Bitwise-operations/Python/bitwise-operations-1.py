def bitwise_built_ins(width, a, b):
    mask = (1 << width) - 1
    print(f"""\
    AND:     0b{a :0{width}b}
           & 0b{b :0{width}b}
           = 0b{(a & b) & mask :0{width}b}

    OR:      0b{a :0{width}b}
           | 0b{b :0{width}b}
           = 0b{(a | b) & mask :0{width}b}

    XOR:     0b{a :0{width}b}
           ^ 0b{b :0{width}b}
           = 0b{(a ^ b) & mask :0{width}b}

    NOT:   ~ 0b{a :0{width}b}
           = 0b{(~a) & mask :0{width}b}

    SHIFTS

      RIGHT:   0b{a :0{width}b} >> 1
             = 0b{(a >> 1) & mask :0{width}b}

      LEFT:    0b{a :0{width}b} << 1
             = 0b{(a << 1) & mask :0{width}b}
""")

def rotr(width, a, n):
    "Rotate a, n times to the right"
    if n < 0:
        return rotl(width, a, -n)
    elif n == 0:
        return a
    else:
        mask = (1 << width) - 1
        a, n = a & mask, n % width
        return ((a >> n)    # top moved down
                | ((a & ((1 << n) - 1))   # Bottom masked...
                   << (width - n)))  # ... then moved up

def rotl(width, a, n):
    "Rotate a, n times to the left"
    if n < 0:
        return rotr(width, a, -n)
    elif n == 0:
        return a
    else:
        mask = (1 << width) - 1
        a, n = a & mask, n % width
        return (((a << n) & mask)      # bottom shifted up and masked
                | (a >> (width - n)))  # Top moved down

def asr(width, a, n):
    "Arithmetic shift a, n times to the right. (sign preserving)."
    mask, top_bit_mask = ((1 << width) - 1), 1 << (width - 1)
    if n < 0:
        return  (a << -n) & mask
    elif n == 0:
        return a
    elif n >= width:
        return mask if a & top_bit_mask else 0
    else:
        a = a & mask
        if a & top_bit_mask:    # Sign bit set?
            signs = (1 << n) - 1
            return a >> n | (signs << width - n)
        else:
            return a >> n


def helper_funcs(width, a):
    mask, top_bit_mask = ((1 << width) - 1), 1 << (width - 1)
    aa = a | top_bit_mask  # a with top bit set
    print(f"""\
    ROTATIONS

      RIGHT:   rotr({width}, 0b{a :0{width}b}, 1)
               =       0b{rotr(width, a, 1) :0{width}b}
               rotr({width}, 0b{a :0{width}b}, 2)
               =       0b{rotr(width, a, 2) :0{width}b}
               rotr({width}, 0b{a :0{width}b}, 4)
               =       0b{rotr(width, a, 4) :0{width}b}

      LEFT:    rotl({width}, 0b{a :0{width}b}, 1)
               =       0b{rotl(width, a, 1) :0{width}b}
               rotl({width}, 0b{a :0{width}b}, 2)
               =       0b{rotl(width, a, 2) :0{width}b}
               rotl({width}, 0b{a :0{width}b}, 4)
               =       0b{rotl(width, a, 4) :0{width}b}

    SIGN-EXTENDING ARITHMETIC SHIFT RIGHT

               asr({width}, 0b{a :0{width}b}, 1)
               =      0b{asr(width, a, 1) :0{width}b}
               asr({width}, 0b{aa :0{width}b}, 1)
               =      0b{asr(width, aa, 1) :0{width}b}
               asr({width}, 0b{a :0{width}b}, 2)
               =      0b{asr(width, a, 2) :0{width}b}
               asr({width}, 0b{aa :0{width}b}, 2)
               =      0b{asr(width, aa, 2) :0{width}b}
               asr({width}, 0b{a :0{width}b}, 4)
               =      0b{asr(width, a, 4) :0{width}b}
               asr({width}, 0b{aa :0{width}b}, 4)
               =      0b{asr(width, aa, 4) :0{width}b}
""")

if __name__ == '__main__':
    bitwise_built_ins(8, 27, 125)
    helper_funcs(8, 27)
