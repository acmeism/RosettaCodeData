# explicit concatentation
$_ = 'byte';
$_ = 'kilo' ~ $_;
.say;

# interpolation as concatenation
$_ = 'buck';
$_ = "mega$_";
.say;

# lvalue substr
$_ = 'bit';
substr-rw($_,0,0) = 'nano';
.say;

# regex substitution
$_ = 'fortnight';
s[^] = 'micro';
.say;

# reversed append assignment
$_ = 'cooper';
$_ [R~]= 'mini';
.say;
