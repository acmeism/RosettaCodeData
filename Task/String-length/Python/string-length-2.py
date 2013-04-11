#!/bin/env python
# -*- coding: UTF-8 -*-
s = "møøse"
assert len(s) == 5
assert len(s.encode('UTF-8')) == 7
assert len(s.encode('UTF-16')) == 12 # The extra character is probably a leading Unicode byte-order mark (BOM).
