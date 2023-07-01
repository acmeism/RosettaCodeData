variable sa = "Hello, World", aa = Char_Type[strlen(sa)+1];
init_char_array(aa, sa);
array_reverse(aa);
% print(aa);

% Unfortunately, strjoin() only joins strings, so we map char()
% [sadly named: actually converts char into single-length string]
% onto the array:

print( strjoin(array_map(String_Type, &char, aa), "") );
