#!/usr/local/bin/a68g --script #
# -*- coding: utf-8 -*- #

MODE SCALAR = COMPL;
PROC (COMPL)COMPL scalar exp = complex exp;
PR READ "Template.Fast_Fourier_transform.a68" PR

FORMAT real fmt := $g(0,3)$;
FORMAT real array fmt := $f(real fmt)", "$;
FORMAT compl fmt := $f(real fmt)"⊥"f(real fmt)$;
FORMAT compl array fmt := $f(compl fmt)", "$;

test:(
  []COMPL
    tooth wave ft = fft((1, 1, 1, 1, 0, 0, 0, 0)),
    one and a quarter wave ft = fft((0, 0.924, 0.707,-0.383,-1,-0.383, 0.707, 0.924,
                                     0,-0.924,-0.707, 0.383, 1, 0.383,-0.707,-0.924));
  printf((
    $"Tooth wave: "$,compl array fmt, tooth wave ft, $l$,
    $"1¼ cycle wave: "$, compl array fmt, one and a quarter wave ft, $l$
  ))
)
