# gnu assembler syntax
substitution_cipher: # char* str (a0), uint len (a1), const char lowerkey[26] (a2), const char upperkey[26] (a3)
        # set up temporary registers t0, t1, t2, t3
        li t0, 'a
        li t1, 'z
        li t2, 'A
        li t3, 'Z
        # char tmp (t4)
        # char* cipher (t5)

        .dcB:                           # begin loop
        beqz a1, .dcE                   # break condition
        lb t4, 0(a0)                    # load one character from a0
        blt t4, t0, .dcU                # lowercase check
        bgt t4, t1, .dcI
        addi t4, t4, -'a
        mv t5, a2
        j .dcA
        .dcU:                           # uppercase check
        blt t4, t2, .dcI
        bgt t4, t3, .dcI
        addi t4, t4, -'A
        mv t5, a3
        .dcA:                           # convert and save ciphertext character
        add t5, t5, t4
        lb t5, 0(t5)
        sb t5, 0(a0)
        .dcI:                           # increment registers
        addi a1, a1, -1
        addi a0, a0, 1
        j .dcB
        .dcE: ret                       # end loop

# You can use the following cipher keys, which correspond to the Atbash cipher,
# to test the substitution. These keys are self-inverse, which means that
# applying them twice to a given plaintext yields the original plaintext again.
latbash:        .ascii "zyxwvutsrqponmlkjihgfedcba"
uatbash:        .ascii "ZYXWVUTSRQPONMLKJIHGFEDCBA"

# For keys that are non-self-inverse, you will need to keep a separate set of
# encryption and decryption keys.
lzebras:        .ascii "zebrascdfghijklmnopqtuvwxy"
uzebras:        .ascii "ZEBRASCDFGHIJKLMNOPQTUVWXY"
ldzebras:       .ascii "ecghbijklmnopqrstdfuvwxyza"
udzebras:       .ascii "ECGHBIJKLMNOPQRSTDFUVWXYZA"
