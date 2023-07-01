begin
    % example using a record type to return multiple values from a procedure %
    record Element ( string(2) symbol; integer atomicNumber );
    reference(Element) procedure getElement( integer value n ) ;
    begin
        Element( if      n < 1 then   "?<"
                 else if n > 3 then   "?>"
                 else case n of ( %1% "H"
                                , %2% "He"
                                , %3% "Li"
                                )
               , n
               )
    end getElement ;
    % test the procedure %
    begin
        reference(Element) elementData;
        for n := 0 until 4 do begin
            elementData := getElement(n);
            write( s_w := 0, i_w := 1
                 , atomicNumber(elementData)
                 , " "
                 , symbol(elementData)
                 );
        end
    end

end.
