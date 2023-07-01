BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

cmw:{[s;b]                                                   / [str;blocks]
  $[0=count s; 1b;                                           /   empty string
    not any found:any each b=s 0; 0b;                        /   cannot proceed
    any(1_s).z.s/:b(til count b)except/:where found] }
