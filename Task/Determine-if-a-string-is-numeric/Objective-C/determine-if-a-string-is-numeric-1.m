if( [[NSScanner scannerWithString:@"-123.4e5"] scanFloat:NULL] )
	NSLog( @"\"-123.4e5\" is numeric" );
else
	NSLog( @"\"-123.4e5\" is not numeric" );
if( [[NSScanner scannerWithString:@"Not a number"] scanFloat:NULL] )
	NSLog( @"\"Not a number\" is numeric" );
else
	NSLog( @"\"Not a number\" is not numeric" );
// prints: "-123.4e5" is numeric
// prints: "Not a number" is not numeric
