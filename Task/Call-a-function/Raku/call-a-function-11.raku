{
state $n;

multi f ()          {                                    print ' f' ~ ++$n }
multi f ($a)        { die if 1  != $a;                   print ' f' ~ ++$n }
multi f ($a,$b)     { die if 3  != $a+$b;                print ' f' ~ ++$n }
multi f (@a)        { die if @a != [2,3,4];              print ' f' ~ ++$n }
multi f ($a,$b,$c)  { die if 2  != $a || 4 != $c;        print ' f' ~ ++$n }
sub   g ($a,*@b)    { die if @b != [2,3,4] || 1 != $a;   print ' g' ~ ++$n }

my \i = ->          {                                    print ' i' ~ ++$n }
my \l = -> $a       { die if 1 != $a;                    print ' l' ~ ++$n }
my \m = -> $a,$b    { die if 1 != $a || 2 != $b;         print ' m' ~ ++$n }
my \n = -> @a       { die if @a != [2,3,4];              print ' n' ~ ++$n }

Int.^add_method( 'j', method ()
                    { die if 1 != self;                  print ' j' ~ ++$n } );
Int.^add_method( 'k', method ($a)
                    { die if 1 != self || 2 != $a;       print ' k' ~ ++$n } );
Int.^add_method( 'h', method (@a)
                    { die if @a != [2,3,4] || 1 != self; print ' h' ~ ++$n } );

my $ref   =  &f;  # soft ref
my $f    :=  &f;  # hard ref
my $g    :=  &g;  # hard ref
my $f-sym = '&f'; # symbolic ref
my $g-sym = '&g'; # symbolic ref
my $j-sym =  'j'; # symbolic ref
my $k-sym =  'k'; # symbolic ref
my $h-sym =  'h'; # symbolic ref

# Calling a function with no arguments:

f;            #  1  as list operator
f();          #  2  as function
i.();         #  3  as function, explicit postfix form  # defined via pointy-block
$ref();       #  4  as object invocation
$ref.();      #  5  as object invocation, explicit postfix
&f();         #  6  as object invocation
&f.();        #  7  as object invocation, explicit postfix
::($f-sym)(); #  8  as symbolic ref

# Calling a function with exactly one argument:

f 1;          #   9  as list operator
f(1);         #  10  as named function
l.(1);        #  11  as named function, explicit postfix  # defined via pointy-block
$f(1);        #  12  as object invocation (must be hard ref)
$ref.(1);     #  13  as object invocation, explicit postfix
1.$f;         #  14  as pseudo-method meaning $f(1) (hard ref only)
1.$f();       #  15  as pseudo-method meaning $f(1) (hard ref only)
1.&f;         #  16  as pseudo-method meaning &f(1) (is hard f)
1.&f();       #  17  as pseudo-method meaning &f(1) (is hard f)
1.j;          #  18  as method via dispatcher             # requires custom method, via 'Int.^add_method'
1.j();        #  19  as method via dispatcher
1."$j-sym"(); #  20  as method via dispatcher, symbolic

# Calling a function with exactly two arguments:

f 1,2;         #  21  as list operator
f(1,2);        #  22  as named function
m.(1,2);       #  23  as named function, explicit postfix  # defined via pointy-block
$ref(1,2);     #  24  as object invocation (must be hard ref)
$ref.(1,2);    #  25  as object invocation, explicit postfix
1.$f: 2;       #  26  as pseudo-method meaning $f(1,2) (hard ref only)
1.$f(2);       #  27  as pseudo-method meaning $f(1,2) (hard ref only)
1.&f: 2;       #  28  as pseudo-method meaning &f(1,2) (is hard f)
1.&f(2);       #  29  as pseudo-method meaning &f(1,2) (is hard f)
1.k: 2;        #  30  as method via dispatcher             # requires custom method, via 'Int.^add_method'
1.k(2);        #  31  as method via dispatcher
1."$k-sym"(2); #  32  as method via dispatcher, symbolic

# Calling a function with a variable number of arguments (varargs):

my @args = 2,3,4;

f @args;           #  33  as list operator
f(@args);          #  34  as named function
n.(@args);         #  35  as named function, explicit postfix   # defined via pointy-block
$ref(@args);       #  36  as object invocation (must be hard ref)
$ref.(@args);      #  37  as object invocation, explicit postfix
1.$g: @args;       #  38  as pseudo-method meaning $f(1,@args) (hard ref)
1.$g(@args);       #  39  as pseudo-method meaning $f(1,@args) (hard ref)
1.&g: @args;       #  40  as pseudo-method meaning &f(1,@args)
1.&g(@args);       #  41  as pseudo-method meaning &f(1,@args)
1.h: @args;        #  42  as method via dispatcher              # requires custom method, via 'Int.^add_method'
1.h(@args);        #  43  as method via dispatcher
1."$h-sym"(@args); #  44  as method via dispatcher, symbolic
f(|@args);         #  45  equivalent to f(1,2,3)

}
