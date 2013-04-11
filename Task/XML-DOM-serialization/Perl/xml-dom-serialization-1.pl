use XML::Simple;
print XMLout( { root => { element => "Some text here" } }, NoAttr => 1, RootName => "" );
