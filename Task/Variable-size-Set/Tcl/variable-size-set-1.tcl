% proc format_trace {fmt _var el op} {upvar 1 $_var v; set v [format $fmt $v]}

% trace var foo w {format_trace %10s}
% puts "/[set foo bar]/"
/       bar/

% trace var grill w {format_trace %-10s}
% puts "/[set grill bar]/"
/bar       /
