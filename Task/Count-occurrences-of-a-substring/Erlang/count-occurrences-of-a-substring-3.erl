main( String, Sub ) -> erlang:length( binary:split(binary:list_to_bin(String), binary:list_to_bin(Sub), [global]) ) - 1.
