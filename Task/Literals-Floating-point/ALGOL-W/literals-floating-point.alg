begin
    real r; long real lr;
    % floating point literals have the following forms:                      %
    %    1 - a digit sequence followed by "." followed by a digit sequence   %
    %    2 - a digit sequence followed by "."                                %
    %    3 - "." followed by a digit sequence                                %
    %    4 - one of the above, followed by "'" followed by an optional sign  %
    %        folloed by a digit sequence                                     %
    % the literal can be followed by "L", indicating it is long real         %
    % the literal can be followed by "I", indicating it is imaginary         %
    % the literal can be followed by "LI" or "IL" indicating it is a long    %
    % imaginary number                                                       %
    % an integer literal ( digit sequence ) can also be used where a         %
    % floating point literal is required                                     %
    % non-imaginary examples:                                                %
    r  := 1.23;
    r  := 1.;
    r  := .9;
    r  := 1.23'5;
    r  := 1.'+4;
    r  := .9'-12;
    r  := 7;
    lr := 5.4321L;
end.
