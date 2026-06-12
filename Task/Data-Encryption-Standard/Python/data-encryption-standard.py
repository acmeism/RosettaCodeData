#!/usr/bin/python
#!/usr/bin/python

# Permutation tables and Sboxes
IP = (
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9,  1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7
)
IP_INV = (
    40,  8, 48, 16, 56, 24, 64, 32,
    39,  7, 47, 15, 55, 23, 63, 31,
    38,  6, 46, 14, 54, 22, 62, 30,
    37,  5, 45, 13, 53, 21, 61, 29,
    36,  4, 44, 12, 52, 20, 60, 28,
    35,  3, 43, 11, 51, 19, 59, 27,
    34,  2, 42, 10, 50, 18, 58, 26,
    33,  1, 41,  9, 49, 17, 57, 25
)
PC1 = (
    57, 49, 41, 33, 25, 17, 9,
    1,  58, 50, 42, 34, 26, 18,
    10, 2,  59, 51, 43, 35, 27,
    19, 11, 3,  60, 52, 44, 36,
    63, 55, 47, 39, 31, 23, 15,
    7,  62, 54, 46, 38, 30, 22,
    14, 6,  61, 53, 45, 37, 29,
    21, 13, 5,  28, 20, 12, 4
)
PC2 = (
    14, 17, 11, 24, 1,  5,
    3,  28, 15, 6,  21, 10,
    23, 19, 12, 4,  26, 8,
    16, 7,  27, 20, 13, 2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
)

E  = (
    32, 1,  2,  3,  4,  5,
    4,  5,  6,  7,  8,  9,
    8,  9,  10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32, 1
)

Sboxes = {
    0: (
        14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
        0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
        4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
        15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
    ),
    1: (
        15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
        3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
        0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
        13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
    ),
    2: (
        10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
        13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
        13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
        1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
    ),
    3: (
        7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
        13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
        10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
        3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
    ),
    4: (
        2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
        14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
        4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
        11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
    ),
    5: (
        12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
        10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
        9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
        4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
    ),
    6: (
        4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
        13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
        1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
        6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
    ),
    7: (
        13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
        1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
        7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
        2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
    )
}

P = (
    16,  7, 20, 21,
    29, 12, 28, 17,
    1, 15, 23, 26,
    5, 18, 31, 10,
    2,  8, 24, 14,
    32, 27,  3,  9,
    19, 13, 30,  6,
    22, 11, 4,  25
)

def encrypt(msg, key, decrypt=False):
    # only encrypt single blocks
    assert isinstance(msg, int) and isinstance(key, int)
    assert not msg.bit_length() > 64
    assert not key.bit_length() > 64

    # permutate by table PC1
    key = permutation_by_table(key, 64, PC1) # 64bit -> PC1 -> 56bit

    # split up key in two halves
    # generate the 16 round keys
    C0 = key >> 28
    D0 = key & (2**28-1)
    round_keys = generate_round_keys(C0, D0) # 56bit -> PC2 -> 48bit

    msg_block = permutation_by_table(msg, 64, IP)
    L0 = msg_block >> 32
    R0 = msg_block & (2**32-1)

    # apply thr round function 16 times in following scheme (feistel cipher):
    L_last = L0
    R_last = R0
    for i in range(1,17):
        if decrypt: # just use the round keys in reversed order
            i = 17-i
        L_round = R_last
        R_round = L_last ^ round_function(R_last, round_keys[i])
        L_last = L_round
        R_last = R_round

    # concatenate reversed
    cipher_block = (R_round<<32) + L_round

    # final permutation
    cipher_block = permutation_by_table(cipher_block, 64, IP_INV)

    return cipher_block

def round_function(Ri, Ki):
    # expand Ri from 32 to 48 bit using table E
    Ri = permutation_by_table(Ri, 32, E)

    # xor with round key
    Ri ^= Ki

    # split Ri into 8 groups of 6 bit
    Ri_blocks = [((Ri & (0b111111 << shift_val)) >> shift_val) for shift_val in (42,36,30,24,18,12,6,0)]

    # interpret each block as address for the S-boxes
    for i, block in enumerate(Ri_blocks):
        # grab the bits we need
        row = ((0b100000 & block) >> 4) + (0b1 & block)
        col = (0b011110 & block) >> 1
        # sboxes are stored as one-dimensional tuple, so we need to calc the index this way
        Ri_blocks[i] = Sboxes[i][16*row+col]

    # pack the blocks together again by concatenating
    Ri_blocks = zip(Ri_blocks, (28,24,20,16,12,8,4,0))
    Ri = 0
    for block, lshift_val in Ri_blocks:
        Ri += (block << lshift_val)

    # another permutation 32bit -> 32bit
    Ri = permutation_by_table(Ri, 32, P)

    return Ri

def permutation_by_table(block, block_len, table):
    # quick and dirty casting to str
    block_str = bin(block)[2:].zfill(block_len)
    perm = []
    for pos in range(len(table)):
        perm.append(block_str[table[pos]-1])
    return int(''.join(perm), 2)

def generate_round_keys(C0, D0):
    # returns dict of 16 keys (one for each round)

    round_keys = dict.fromkeys(range(0,17))
    lrot_values = (1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1)

    # left-rotation function
    lrot = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))

    # initial rotation
    C0 = lrot(C0, 0, 28)
    D0 = lrot(D0, 0, 28)
    round_keys[0] = (C0, D0)

    # create 16 more different key pairs
    for i, rot_val in enumerate(lrot_values):
        i+=1
        Ci = lrot(round_keys[i-1][0], rot_val, 28)
        Di = lrot(round_keys[i-1][1], rot_val, 28)
        round_keys[i] = (Ci, Di)

    # round_keys[1] for first round
    #           [16] for 16th round
    # dont need round_keys[0] anymore, remove
    del round_keys[0]

    # now form the keys from concatenated CiDi 1<=i<=16 and by apllying PC2
    for i, (Ci, Di) in round_keys.items():
        Ki = (Ci << 28) + Di
        round_keys[i] = permutation_by_table(Ki, 56, PC2) # 56bit -> 48bit

    return round_keys

k = 0x0e329232ea6d0d73 # 64 bit
k2 = 0x133457799BBCDFF1
m = 0x8787878787878787
m2 = 0x0123456789ABCDEF

def prove(key, msg):
    print('key:       {:x}'.format(key))
    print('message:   {:x}'.format(msg))
    cipher_text = encrypt(msg, key)
    print('encrypted: {:x}'.format(cipher_text))
    plain_text = encrypt(cipher_text, key, decrypt=True)
    print('decrypted: {:x}'.format(plain_text))

prove(k, m)
print('----------')
prove(k2, m2)

