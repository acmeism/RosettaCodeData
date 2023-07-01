say $_ , ': ', (1..*).map( *.base(2) ).first: * %% $_ for flat 1..10, 95..105; # etc.
