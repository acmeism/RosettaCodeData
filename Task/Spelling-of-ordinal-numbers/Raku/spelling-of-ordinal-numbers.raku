use Lingua::EN::Numbers;

# The task
+$_ ?? printf( "Type: \%-14s %16s : %s\n", .^name, $_, .&ordinal ) !! say "\n$_:" for

# Testing
'Required tests',
1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003,

'Optional tests - different forms of 123',
'Numerics',
123, 00123.0, 1.23e2, 123+0i,

'Allomorphs',
|<123 1_2_3 00123.0 1.23e2 123+0i 0b1111011 0o173 0x7B 861/7>,

'Numeric Strings',
|'1_2_3 00123.0 1.23e2 123+0i 0b1111011 0o173 0x7B 861/7'.words,

'Unicode Numeric Strings',
# (Only using groups of digits from the same Unicode block. Technically,
# digits from any block could be combined with digits from any other block.)
|(^0x1FFFF).grep( { .chr ~~ /<:Nd>/ and .unival == 1|2|3 }).rotor(3)».chr».join,

'Role Mixin',
'17' but 123;
