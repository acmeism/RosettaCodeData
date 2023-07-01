import openldap;
import std.stdio;

void main() {
  auto ldap = LDAP("ldap://localhost");
  auto r = ldap.search_s("dc=example,dc=com", LDAP_SCOPE_SUBTREE, "(uid=%s)".format("test"));
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
