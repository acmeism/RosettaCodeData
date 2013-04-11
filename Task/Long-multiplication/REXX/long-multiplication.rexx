/*REXX program to use and show  large  multiplication results.          */
numeric digits 1000                    /*up to around 8 meg is feasible.*/
say '2^64 * 2^64         = '     2**64  *  2**64
say '2^64 * 2^64 * 2^128 = '    (2**64) * (2**64) * (2**128)
