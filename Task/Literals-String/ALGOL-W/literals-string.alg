begin
    % String literals are enclosed in double-quotes in Algol W.              %
    % There isn't a separate character type but strings of lenghth one can   %
    % be used instead.                                                       %
    % There are no escaping conventions used in string literals, except that %
    % in order to have a double-quote character in a string, two double      %
    % quotes must be used.                                                   %
    % Examples:                                                              %

    % write a single character                                               %
    write( "a" );

    % write a double-quote character                                         %
    write( """" );

    % write a multi-character string - note the "\" is not an escape         %
    % and a\nb will appear on the output, not a and b on separate lines      %
    write( "a\nb" );

end.
