#!/bin/sh

sbcl --script xiaolin_wu_line_algorithm.lisp > alpha.pgm
pamgradient black black darkblue darkblue 800 800 > bluegradient.pam
pamgradient red red magenta magenta 800 800 > redgradient.pam
pamcomp -alpha=alpha.pgm redgradient.pam bluegradient.pam | pamtopng > image.png
