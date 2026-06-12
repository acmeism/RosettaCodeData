#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

MODE PERMELEM = STRING;
PR READ "prelude_permutations_with_repetitions.a68" PR;

INT lead actor = 1, co star = 2;
PERMELEMLIST actors list = ("Chris Ciaffa", "Keith Urban","Tom Cruise",
                            "Katie Holmes","Mimi Rogers","Nicole Kidman");

FLEX[0]PERMELEMLIST combination := (actors list, actors list, actors list, actors list);

FORMAT partner fmt = $g"; "$;
test:(
# FOR PERMELEMELEM candidate in # perm gen elemlist(combination #) DO (#,
##   (PERMELEMLIST candidate)VOID: (
    printf((partner fmt,candidate));
    IF candidate[lead actor] = "Keith Urban" AND candidate[co star]="Nicole Kidman" OR
       candidate[co star] = "Keith Urban" AND candidate[lead actor]="Nicole Kidman" THEN
      print((" => Sunday + Faith as extras", new line)); # children #
      done
    FI;
    print(new line)
# OD #));
  done: SKIP
)
