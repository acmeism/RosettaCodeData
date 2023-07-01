#!/bin/env python
# -*- coding: UTF-8 -*-
s = "møøse"
assert len(s) == 5
assert len(s.encode('UTF-8')) == 7
assert len(s.encode('UTF-16-BE')) == 10 # There are 3 different UTF-16 encodings: LE and BE are little endian and big endian respectively, the third one (without suffix) adds 2 extra leading bytes: the byte-order mark (BOM).
u="𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
assert len(u.encode()) == 28
assert len(u.encode('UTF-16-BE')) == 28
