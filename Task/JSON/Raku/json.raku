use JSON::Tiny;

say from-json '{ "foo": 1, "bar": [10, "apples"] }';
say to-json   %( blue => [1,2], ocean => "water" );
