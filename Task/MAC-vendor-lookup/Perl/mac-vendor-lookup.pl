#!/usr/bin/env perl -T
use v5.18.2;
use warnings;
use LWP;
use Time::HiRes qw(sleep);

our $VERSION = 1.000_000;

my $ua = LWP::UserAgent->new;

no warnings 'qw';
my @macs = qw(
    FC-A1-3EFC:FB:FB:01:FA:21 00,0d,4b
    Rhubarb                   00-14-22-01-23-45
    10:dd:b1                  D4:F4:6F:C9:EF:8D
    FC-A1-3E                  88:53:2E:67:07:BE
    23:45:67                  FC:FB:FB:01:FA:21
    BC:5F:F4
);

while (my $mac = shift @macs) {
    my $vendor = get_mac_vendor($mac);
    if ($vendor) {
        say "$mac = $vendor";
    }
    sleep 1.5 if @macs;
}

sub get_mac_vendor {
    my $s = shift;

    my $req = HTTP::Request->new( GET => "http://api.macvendors.com/$s" );
    my $res = $ua->request($req);

    # A error related to the network connectivity or the API should
    # return a null result.
    if ( $res->is_error ) {
        return;
    }

    # A MAC address that does not return a valid result should
    # return the String "N/A".
    if (  !$res->content
        or $res->content eq 'Vendor not found' )
    {
        return 'N/A';
    }

    return $res->content;
}

# IEEE 802:
#  Six groups of two hexadecimal digits separated by hyphens or colons,
#    like 01-23-45-67-89-ab or 01:23:45:67:89:ab
#  Three groups of four hexadecimal digits separated by dots (.),
#    like 0123.4567.89ab
#sub validmac {
#    my $s = shift;
#
#    my $hex    = qr{ [A-Fa-f[:digit:]] }xms;
#    my $hex2ws = qr{ [-:] $hex{2} }xms;
#
#    if (   $s =~ m{\A $hex{2} $hex2ws{5} \z}xms
#        or $s =~ m{\A $hex{4} [.] $hex{4}  [.] $hex{4} \z}xms )
#    {
#        return 'true';
#    }
#    return;
#}
