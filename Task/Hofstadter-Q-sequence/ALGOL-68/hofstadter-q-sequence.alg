#!/usr/local/bin/a68g --script #

INT n = 100000;
main:
(
        INT flip;
        [n]INT q;

        q[1] := q[2] := 1;

        FOR i FROM 3 TO n DO
                q[i] := q[i - q[i - 1]] + q[i - q[i - 2]] OD;

        FOR i TO 10 DO
                printf(($g(0)$, q[i], $b(l,x)$, i = 10)) OD;

        printf(($g(0)l$, q[1000]));

        flip := 0;
        FOR i TO n-1 DO
                flip +:= ABS (q[i] > q[i + 1]) OD;

        printf(($"flips: "g(0)l$, flip))
)
