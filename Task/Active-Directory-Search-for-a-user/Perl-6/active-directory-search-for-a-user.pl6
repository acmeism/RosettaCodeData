#!/usr/bin/env perl6

# 20190718 Perl 6 programming solution
# https://github.com/perl6/doc/issues/2898
# https://www.facebook.com/groups/perl6/permalink/2379873082279037/

# Reference:
# https://github.com/Altai-man/cro-ldap
# https://www.forumsys.com/tutorials/integration-how-to/ldap/online-ldap-test-server/

use v6.d;
use Cro::LDAP::Client;

my $client = await Cro::LDAP::Client.connect('ldap://ldap.forumsys.com');

my $bind = await $client.bind(
   name=>'cn=read-only-admin,dc=example,dc=com',password=>'password'
);
die $bind.error-message if $bind.result-code;

my $resp = $client.search(
   :dn<dc=example,dc=com>, base=>"ou=mathematicians", filter=>'(&(uid=gauss))'
);

react {
   whenever $resp -> $entry {
      for $entry.attributes.kv -> $k, $v {
         my $value-str = $v ~~ Blob ?? $v.decode !! $v.map(*.decode);
         note "$k -> $value-str";
      }
   }
}
