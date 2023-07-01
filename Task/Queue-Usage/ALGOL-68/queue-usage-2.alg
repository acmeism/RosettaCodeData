#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

MODE OBJVALUE = DIETITEM;
PR read "prelude/link.a68" PR;# c.f. [[rc:Queue/Definition]] #
PR read "prelude/queue_base.a68" PR; # c.f. [[rc:Queue/Definition]] #

PR read "test/data_stigler_diet.a68" PR;
OBJQUEUE example queue; obj queue init(example queue);

FOR i TO UPB stigler diet DO
# obj queue put(example queue, stigler diet[i]) or ... #
  stigler diet[i] +=: example queue
OD;

printf($"Get remaining values from queue:"l$);
WHILE NOT obj queue is empty(example queue) DO
# OR example queue ISNT obj queue empty #
  printf((diet item fmt, obj queue get(example queue), $l$))
OD
