MODE ENTITY = STRUCT([6]CHAR name, INT creation);
FORMAT entity repr = $"Name: "g", Created:"g$;
MODE PERSON = STRUCT(ENTITY entity, STRING email);
FORMAT person repr = $f(entity repr)", Email: "g$;

PERSON instance1 := PERSON(ENTITY("Cletus", 20080808), "test+1@localhost.localdomain");
print((name OF entity OF instance1, new line));

ENTITY instance2 := ENTITY("Entity",20111111);
print((name OF instance2, new line));

FILE target;
INT errno := open(target, "rows.dat", stand back channel); # open file #

#  Serialise #
put(target,(instance1, new line, instance2, new line));
printf(($"Serialised..."l$));

close(target); # flush file stream #
errno := open(target, "rows.dat", stand back channel); # load again #

# Unserialise #
PERSON i1;
ENTITY i2;
get(target,(i1, new line, i2, new line));
printf(($"Unserialised..."l$));

printf((person repr, i1, $l$));
printf((entity repr, i2, $l$))
