# String creation #
STRING a,b,c,d,e,f,g,h,i,j,l,r;
a := "hello world";
print((a, new line));

# String destruction (for garbage collection) #
b := ();
BEGIN
  LOC STRING lb := "hello earth";  # allocate off the LOC stack  #
  HEAP STRING hb := "hello moon"; # allocate out of the HEAP space #
  ~
END; # local variable "lb" has LOC stack space recovered at END #

# String assignment #
c := "a"+REPR 0+"b";
print (("string length c:", UPB c, new line));# ==> 3 #

# String comparison #
l := "ab"; r := "CD";

BOOL result;
FORMAT summary = $""""g""" is "b("","NOT ")"lexicographically "g" """g""""l$ ;

result := l <  r OR l LT r;              printf((summary, l, result, "less than", r));
result := l <= r OR l LE r # OR l ≤ r #; printf((summary, l, result, "less than or equal to", r));
result := l  = r OR l EQ r;              printf((summary, l, result, "equal to", r));
result := l /= r OR l NE r # OR l ≠ r #; printf((summary, l, result, "not equal to", r));
result := l >= r OR l GE r # OR l ≥ r #; printf((summary, l, result, "greater than or equal to", r));
result := l >  r OR l GT r;              printf((summary, l, result, "greater than", r));

# String cloning and copying #
e := f;

# Check if a string is empty #
IF g = "" THEN print(("g is empty", new line)) FI;
IF UPB g = 0 THEN print(("g is empty", new line)) FI;

# Append a byte to a string #
h +:= "A";

# Append a string to a string #
h +:= "BCD";
h PLUSAB "EFG";

# Prepend a string to a string - because STRING addition isn't communitive #
"789" +=: h;
"456" PLUSTO h;
print(("The result of prepends and appends: ", h, new line));

# Extract a substring from a string #
i := h[2:3];
print(("Substring 2:3 of ",h," is ",i, new line));

# Replace every occurrences of a byte (or a string) in a string with another string #
PROC replace = (STRING string, old, new, INT count)STRING: (
  INT pos;
  STRING tail := string, out;
  TO count WHILE string in string(old, pos, tail) DO
    out +:= tail[:pos-1]+new;
    tail := tail[pos+UPB old:]
  OD;
  out+tail
);

j := replace("hello world", "world", "planet", max int);
print(("After replace string: ", j, new line));

INT offset = 7;
# Replace a character at an offset in the string #
j[offset] := "P";
print(("After replace 7th character: ", j, new line));

# Replace a substring at an offset in the string #
j[offset:offset+3] := "PlAN";
print(("After replace 7:10th characters: ", j, new line));

# Insert a string before an offset in the string #
j := j[:offset-1]+"INSERTED "+j[offset:];
print(("Insert string before 7th character: ", j, new line));

# Join strings  #
a := "hel";
b := "lo w";
c := "orld";
d := a+b+c;

print(("a+b+c is ",d, new line));

# Pack a string into the target CPU's word #
BYTES word := bytes pack(d);

# Extract a CHAR from a CPU word #
print(("7th byte in CPU word is: ", offset ELEM word, new line))
