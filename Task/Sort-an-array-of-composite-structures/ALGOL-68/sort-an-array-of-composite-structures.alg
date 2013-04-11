MODE SORTSTRUCT = PERSON;
OP < = (PERSON a,b)BOOL: age OF a < age OF b;
PR READ "prelude/sort.a68" PR;

MODE PERSON = STRUCT (STRING name, INT age);
FORMAT person repr = $"Name: "g", Age: "g(0)l$;

[]SORTSTRUCT person = (("joe", 120), ("foo", 31), ("bar", 51));
printf((person repr, shell sort(person), $l$))
