# 20210306 Perl programming solution

use strict;
use warnings;

use Net::LDAP;

my $ldap = Net::LDAP->new( 'ldap://ldap.forumsys.com' )  or  die "$@";

my $mesg = $ldap->bind( "cn=read-only-admin,dc=example,dc=com",
                        password => "password"                  );

$mesg->code and die $mesg->error;

my $srch = $ldap->search( base   => "dc=example,dc=com",
                          filter => "(|(uid=gauss))"     );

$srch->code and die $srch->error;

foreach my $entry ($srch->entries) { $entry->dump }

$mesg = $ldap->unbind;
