#!/usr/bin/env perl -T
use 5.018_002;
use warnings;
use LWP;

our $VERSION = 1.000_000;

my $ua = LWP::UserAgent->new(
    ssl_opts => {
        SSL_cert_file   => 'certificate.pem',
        SSL_key_file    => 'key.pem',
        verify_hostname => 1,
    }
);
my $req = HTTP::Request->new( GET => 'https://www.example.com' );
my $res = $ua->request($req);
if ( $res->is_success ) {
    say $res->content;
}
else {
    say $res->status_line;
}
