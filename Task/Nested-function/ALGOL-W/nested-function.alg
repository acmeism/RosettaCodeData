begin
    string(30) procedure makeList ( string(2) value separator ) ;
        begin
            string(30) listValue;
            integer counter;
            string(10) procedure makeItem ( string(6) value item
                                          ; integer   value length
                                          ) ;
                begin
                    string(10) listItem;
                    counter := counter + 1;
                    listItem( 0 // 1 ) := code( decode( "0" ) + counter );
                    listItem( 1 // 2 ) := separator;
                    listItem( 3 // 6 ) := item;
                    listItem( 3 + length // 1 ) := code( 10 );
                    listItem
                end; % makeItem %
                counter   := 0;
                listValue := makeItem( "first", 5 );
                listValue(  9 // 10 ) := makeItem( "second", 6 );
                listValue( 19 // 10 ) := makeItem( "third",  5 );
                listValue
         end; % makeList %
    write( makeList( ". " ) )
end.
