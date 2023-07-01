   taskparts 'foo://example.com:8042/over/there?name=ferret#nose'
┌────────┬─────────────┐
│scheme  │foo          │
├────────┼─────────────┤
│host    │example.com  │
├────────┼─────────────┤
│port    │8042         │
├────────┼─────────────┤
│path    │/over/there  │
├────────┼─────────────┤
│query   │┌───────────┐│
│        ││name=ferret││
│        │└───────────┘│
├────────┼─────────────┤
│fragment│nose         │
└────────┴─────────────┘
   taskparts 'urn:example:animal:ferret:nose'
┌──────┬──────────────────────────┐
│scheme│urn                       │
├──────┼──────────────────────────┤
│path  │example:animal:ferret:nose│
└──────┴──────────────────────────┘
   taskparts 'jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true'
┌──────┬──────────────────────────────────────────────────┐
│scheme│jdbc                                              │
├──────┼──────────────────────────────────────────────────┤
│path  │mysql://test_user:ouupppssss@localhost:3306/sakila│
├──────┼──────────────────────────────────────────────────┤
│query │┌───────────────┐                                 │
│      ││profileSQL=true│                                 │
│      │└───────────────┘                                 │
└──────┴──────────────────────────────────────────────────┘
   taskparts 'ftp://ftp.is.co.za/rfc/rfc1808.txt'
┌──────┬────────────────┐
│scheme│ftp             │
├──────┼────────────────┤
│host  │ftp.is.co.za    │
├──────┼────────────────┤
│path  │/rfc/rfc1808.txt│
└──────┴────────────────┘
   taskparts 'http://www.ietf.org/rfc/rfc2396.txt#header1'
┌────────┬────────────────┐
│scheme  │http            │
├────────┼────────────────┤
│host    │www.ietf.org    │
├────────┼────────────────┤
│path    │/rfc/rfc2396.txt│
├────────┼────────────────┤
│fragment│header1         │
└────────┴────────────────┘
   taskparts 'ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two'
┌──────┬─────────────────────────────────┐
│scheme│ldap                             │
├──────┼─────────────────────────────────┤
│host  │[2001:db8::7]                    │
├──────┼─────────────────────────────────┤
│path  │/c=GB                            │
├──────┼─────────────────────────────────┤
│query │┌───────────────────────────────┐│
│      ││objectClass=one&objectClass=two││
│      │└───────────────────────────────┘│
└──────┴─────────────────────────────────┘
   taskparts 'mailto:John.Doe@example.com'
┌──────┬────────────────────┐
│scheme│mailto              │
├──────┼────────────────────┤
│path  │John.Doe@example.com│
└──────┴────────────────────┘
   taskparts 'news:comp.infosystems.www.servers.unix'
┌──────┬─────────────────────────────────┐
│scheme│news                             │
├──────┼─────────────────────────────────┤
│path  │comp.infosystems.www.servers.unix│
└──────┴─────────────────────────────────┘
   taskparts 'tel:+1-816-555-1212'
┌──────┬───────────────┐
│scheme│tel            │
├──────┼───────────────┤
│path  │+1-816-555-1212│
└──────┴───────────────┘
   taskparts 'telnet://192.0.2.16:80/'
┌──────┬──────────┐
│scheme│telnet    │
├──────┼──────────┤
│host  │192.0.2.16│
├──────┼──────────┤
│port  │80        │
├──────┼──────────┤
│path  │/         │
└──────┴──────────┘
   taskparts 'urn:oasis:names:specification:docbook:dtd:xml:4.1.2'
┌──────┬───────────────────────────────────────────────┐
│scheme│urn                                            │
├──────┼───────────────────────────────────────────────┤
│path  │oasis:names:specification:docbook:dtd:xml:4.1.2│
└──────┴───────────────────────────────────────────────┘
