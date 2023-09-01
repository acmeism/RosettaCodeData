/* gnu assembler syntax */
wireworld:
/* unsigned int width  (a0) */
/* unsigned int height (a1) */
/*        char* grid   (a2) */

        mv      a4,a2

        li      t4,'.  /* conductor */
        li      t5,'H  /* head */
        li      t6,'t  /* tail */

        addi    t2,a0,-1
        addi    t3,a1,-1

        mv      t1,zero
.yloop: /* outer loop (y) */
        mv      t0,zero
.xloop: /* inner loop (x) */

        lb      a5,0(a4)
        bgt     a5,t4,.torh
        blt     a5,t4,.empty

/* conductor: */
/* unsigned int head_count (a3) */
/*        char* test_ptr   (a6) */
/*         char test       (a7) */

        mv      a3,zero
        sub     a6,a4,a0
        addi    a6,a6,-1

0:      beq     t1,zero,1f      /* bounds up */
        beq     t0,zero,0f      /* bounds left */
        lb      a7,0(a6)
        bne     a7,t6,0f
        addi    a3,a3,1

0:      lb      a7,1(a6)
        bne     a7,t6,0f
        addi    a3,a3,1

0:      beq     t0,t2,0f        /* bounds right */
        lb      a7,2(a6)
        bne     a7,t6,0f
        addi    a3,a3,1

0:1:    add     a6,a6,a0
        beq     t0,zero,0f      /* bounds left */
        lb      a7,0(a6)
        bne     a7,t6,0f
        addi    a3,a3,1

0:      beq     t0,t2,0f        /* bounds right */
        lb      a7,2(a6)
        bne     a7,t5,0f
        addi    a3,a3,1

0:      add     a6,a6,a0

        beq     t1,t3,1f        /* bounds down */
        beq     t0,zero,0f      /* bounds left */
        lb      a7,0(a6)
        bne     a7,t5,0f
        addi    a3,a3,1

0:      lb      a7,1(a6)
        bne     a7,t5,0f
        addi    a3,a3,1

0:      beq     t0,t2,0f        /* bounds right */
        lb      a7,2(a6)
        bne     a7,t5,0f
        addi    a3,a3,1

0:1:    beq     a3,zero,.empty
        addi    a3,a3,-2
        bgt     a3,zero,.empty

        mv      a5,t5           /* convert conductor to electron head */
        j       .save

.torh:  beq     a5,t6,.tail

.head:  mv      a5,t6
        j       .save

.tail:  mv      a5,t4
.save:  sb      a5,0(a4)
.empty: /* do nothing */

/* end x-loop */
        addi    a4,a4,1
        addi    t0,t0,1
        bne     t0,a0,.xloop

/* end y-loop */
        addi    t1,t1,1
        bne     t1,a1,.yloop

        ret
