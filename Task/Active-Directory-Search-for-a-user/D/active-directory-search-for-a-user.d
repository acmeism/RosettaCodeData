import openldap;
import std.stdio;

void main() {
  // connect to server
  auto ldap = LDAP("ldap://localhost");

  // search for uid
  auto r = ldap.search_s("dc=example,dc=com", LDAP_SCOPE_SUBTREE, "(uid=%s)".format("test"));

  // show properties
  writeln("Found dn: %s", r[0].dn);
  foreach(k, v; r[0].entry)
    writeln("%s = %s", k, v);

  // bind on found entry
  int b = ldap.bind_s(r[0].dn, "password");
  scope(exit) ldap.unbind;
  if (b)
  {
    writeln("error on binding");
    return;
  }

  // do something
  ...

}
