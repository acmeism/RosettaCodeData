#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

# REQUIRES: #
  MODE QUATSCAL = REAL; # Scalar #
  QUATSCAL quat small scal = small real;

PR READ "prelude/Quaternion.a68" PR;

test:(
    REAL r = 7;
    QUAT q  = (1, 2, 3, 4),
         q1 = (2, 3, 4, 5),
         q2 = (3, 4, 5, 6);

    printf((
        $"r = "      f(quat scal fmt)l$, r,
        $"q = "      f(quat fmt)l$, q,
        $"q1 = "     f(quat fmt)l$, q1,
        $"q2 = "     f(quat fmt)l$, q2,
        $"ABS q = "  f(quat scal fmt)", "$, ABS q,
        $"ABS q1 = " f(quat scal fmt)", "$, ABS q1,
        $"ABS q2 = " f(quat scal fmt)l$, ABS q2,
        $"-q = "     f(quat fmt)l$, -q,
        $"CONJ q = " f(quat fmt)l$, CONJ q,
        $"r + q = "  f(quat fmt)l$, r + q,
        $"q + r = "  f(quat fmt)l$, q + r,
        $"q1 + q2 = "f(quat fmt)l$, q1 + q2,
        $"q2 + q1 = "f(quat fmt)l$, q2 + q1,
        $"q * r = "  f(quat fmt)l$, q * r,
        $"r * q = "  f(quat fmt)l$, r * q,
        $"q1 * q2 = "f(quat fmt)l$, q1 * q2,
        $"q2 * q1 = "f(quat fmt)l$, q2 * q1
    ));

CO
        $"ASSERT q1 * q2 != q2 * q1 = "f(quat fmt)l$, ASSERT q1 * q2 != q2 * q1, $l$;
END CO

    printf((
        $"i*i = "         f(quat fmt)l$, i*i,
        $"j*j = "         f(quat fmt)l$, j*j,
        $"k*k = "         f(quat fmt)l$, k*k,
        $"i*j*k = "       f(quat fmt)l$, i*j*k,
        $"q1 / q2 = "     f(quat fmt)l$, q1 / q2,
        $"q1 / q2 * q2 = "f(quat fmt)l$, q1 / q2 * q2,
        $"q2 * q1 / q2 = "f(quat fmt)l$, q2 * q1 / q2,
        $"1/q1 * q1 = "   f(quat fmt)l$, 1.0/q1 * q1,
        $"q1 / q1 = "     f(quat fmt)l$, q1 / q1,
        $"quat exp(pi * i) = " f(quat fmt)l$, quat exp(pi * i),
        $"quat exp(pi * j) = " f(quat fmt)l$, quat exp(pi * j),
        $"quat exp(pi * k) = " f(quat fmt)l$, quat exp(pi * k)
    ));
    print((REPR(-q1*q2), ", ", REPR(-q2*q1), new line))
)
