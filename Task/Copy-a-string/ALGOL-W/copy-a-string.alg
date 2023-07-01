begin
    % strings are (fixed length) values in algol W. Assignment makes a copy   %
    string(10) a, copyOfA;
    a := "some text";
    copyOfA := a;
    % assignment to a will not change copyOfA                                 %
    a := "new value";
    write( a, copyOfA )
end.
