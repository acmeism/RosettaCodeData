#!/usr/local/bin/a68g --script #

MODE VALUE = INT;
PR READ "Template.Generator.a68" PR

GENVALUE squares = powers(2,), cubes = powers(3,);
GENVALUE fil = gen filtered(squares, cubes,);

printf(($g(0)x$, get list(gen slice(fil, 20, 30, )) ))
