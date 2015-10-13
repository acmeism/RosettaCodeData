1> Str = "Hello".
"Hello"
2> string:sub_string(Str, 2).                   % To strip the string from the right by 1
"ello"
3> string:sub_string(Str, 1, length(Str)-1).    % To strip the string from the left by 1
"Hell"
4> string:sub_string(Str, 2, length(Str)-1).    % To strip the string from both sides by 1
"ell"
