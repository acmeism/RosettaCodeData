sub kronecker_product ( @a, @b ) {
    return (@a X @b).map: { .[0].list X* .[1].list };
}

.say for kronecker_product([ <1 2>, <3 4> ],
                           [ <0 5>, <6 7> ]);
say '';
.say for kronecker_product([ <0 1 0>,   <1 1 1>,   <0 1 0>  ],
                           [ <1 1 1 1>, <1 0 0 1>, <1 1 1 1>]);
