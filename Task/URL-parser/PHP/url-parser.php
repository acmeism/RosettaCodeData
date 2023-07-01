<?php

$urls = array(
    'foo://example.com:8042/over/there?name=ferret#nose',
    'urn:example:animal:ferret:nose',
    'jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true',
    'ftp://ftp.is.co.za/rfc/rfc1808.txt',
    'http://www.ietf.org/rfc/rfc2396.txt#header1',
    'ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two',
    'mailto:John.Doe@example.com',
    'news:comp.infosystems.www.servers.unix',
    'tel:+1-816-555-1212',
    'telnet://192.0.2.16:80/',
    'urn:oasis:names:specification:docbook:dtd:xml:4.1.2',
);

foreach ($urls AS $url) {
    $p = parse_url($url);
    echo $url, PHP_EOL;
    print_r($p);
    echo PHP_EOL;
}
