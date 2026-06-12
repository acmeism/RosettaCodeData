#!/usr/bin/env perl -T
use 5.018_002;
use warnings;
use Try::Tiny;
use XML::LibXML;

our $VERSION = 1.000_000;

my $parser = XML::LibXML->new();

my $good_xml         = '<a>5</a>';
my $bad_xml          = '<a>5<b>foobar</b></a>';
my $xmlschema_markup = <<'END';
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <xsd:element name="a" type="xsd:integer"/>
</xsd:schema>
END

my $xmlschema = XML::LibXML::Schema->new( string => $xmlschema_markup );

for ( $good_xml, $bad_xml ) {
    my $doc = $parser->parse_string($_);
    try {
        $xmlschema->validate($doc);
    }
    finally {
        if (@_) {
            say "Not valid: @_";
        }
        else {
            say 'Valid';
        }
    };
}
