use XML;
use XML::Writer;

say my $document = XML::Document.new(
    XML::Writer.serialize( :root[ :element['Some text here', ], ] )
);
