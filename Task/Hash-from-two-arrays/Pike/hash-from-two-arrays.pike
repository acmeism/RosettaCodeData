array indices = ({ "a", "b", 42 });
array values  = ({ Image.Color(0,0,0), "hello", "world" });
mapping m = mkmapping( indices, values );
write("%O\n", m);
