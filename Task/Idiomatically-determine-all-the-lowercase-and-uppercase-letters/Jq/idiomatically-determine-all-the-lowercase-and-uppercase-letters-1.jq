# The range of codepoints is from m up to but excluding n;
# "class" should be a character class, e.g. Ll or Lu for lower/upper case respectively.
def generate(class; m; n):
  reduce (range(m;n) | [.] | implode | select( test( "\\p{" + class + "}" ))) as $c
    (""; . + $c);
