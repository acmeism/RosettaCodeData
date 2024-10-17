var
    P: PInteger;
begin
    New(P);  //Allocate some memory
    try
        If Assigned(P) Then //...
        begin
            P^ := 42;
        end;
    finally
        Dispose(P); //Release memory allocated by New
    end;
end;
