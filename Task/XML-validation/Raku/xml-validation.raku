# Reference: https://github.com/libxml-raku/LibXML-raku

use v6.d;
use LibXML;
use LibXML::Schema;

my $good_xml         = '<a>5</a>';
my $bad_xml          = '<a>5<b>foobar</b></a>';

my $xsdschema = q:to<EOF>;
   <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <xsd:element name="a" type="xsd:integer"/>
   </xsd:schema>
EOF

my LibXML $p .= new();

for ( $good_xml, $bad_xml ) {
   my $x = $p.parse: :string($_);
   try { LibXML::Schema.new( string => $xsdschema ).validate( $x ) }
   !$! ?? say "Valid." !! say $!.message() ;
}
