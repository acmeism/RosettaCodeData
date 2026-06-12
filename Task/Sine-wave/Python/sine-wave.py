#!/usr/bin/env python

import os
from math import pi, sin

# AU file header
au_header = bytearray(
            [46, 115, 110, 100,   #   ".snd" magic number
              0,   0,   0,  24,   #   start of data bytes
            255, 255, 255, 255,   #   file size is unknown
              0,   0,   0,   3,   #   16 bit PCM samples
              0,   0, 172,  68,   #   44,100 samples/s
              0,   0,   0,   1])  #   mono

def f(x, freq):
    "Compute sine wave as 16-bit integer"
    return round(32000 * sin(2 * pi * freq * x / 44100)) % 65536

def play_sine(freq=440, duration=5, oname="pysine.au"):
    "Play a sine wave for `duration` seconds"
    out = open(oname, 'wb')
    out.write(au_header)
    v = [f(x, freq) for x in range(duration * 44100 + 1)]
    s = []
    for i in v:
        s.append(i >> 8)
        s.append(i % 256)
    out.write(bytearray(s))
    out.close()
    os.system("vlc " + oname)   # starts an external media player to play file

play_sine()
