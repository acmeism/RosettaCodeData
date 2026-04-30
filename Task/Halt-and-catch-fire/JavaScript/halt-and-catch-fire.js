f=()=>f();f();
/* This also does the same thing, but is harder to read */
(f=()=>f())();
