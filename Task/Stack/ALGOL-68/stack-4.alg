#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

MODE OBJVALUE = DIETITEM;
PR read "prelude/next_link.a68" PR;
PR read "prelude/stack_base.a68" PR;

PR read "test/data_stigler_diet.a68" PR;
OBJSTACK example stack; obj stack init(example stack);

FOR i TO UPB stigler diet DO
#  obj stack push(example stack, stigler diet[i]) #
  stigler diet[i] +=: example stack
OD;

printf($"Items popped in reverse:"l$);
WHILE NOT obj stack is empty(example stack) DO
# OR example stack ISNT obj stack empty #
  printf((diet item fmt, obj stack pop(example stack), $l$))
OD
