#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

STRING ofs := "";
FOR i FROM 4 TO argc DO print((ofs, argv(i))); ofs:=" " OD
