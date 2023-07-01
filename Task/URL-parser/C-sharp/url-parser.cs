using System;

namespace RosettaUrlParse
{
    class Program
    {
        static void ParseUrl(string url)
        {
            var u = new Uri(url);
            Console.WriteLine("URL:         {0}", u.AbsoluteUri);
            Console.WriteLine("Scheme:      {0}", u.Scheme);
            Console.WriteLine("Host:        {0}", u.DnsSafeHost);
            Console.WriteLine("Port:        {0}", u.Port);
            Console.WriteLine("Path:        {0}", u.LocalPath);
            Console.WriteLine("Query:       {0}", u.Query);
            Console.WriteLine("Fragment:    {0}", u.Fragment);
            Console.WriteLine();
        }
        static void Main(string[] args)
        {
            ParseUrl("foo://example.com:8042/over/there?name=ferret#nose");
            ParseUrl("urn:example:animal:ferret:nose");
            ParseUrl("jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true");
            ParseUrl("ftp://ftp.is.co.za/rfc/rfc1808.txt");
            ParseUrl("http://www.ietf.org/rfc/rfc2396.txt#header1");
            ParseUrl("ldap://[2001:db8::7]/c=GB?objectClass?one");
            ParseUrl("mailto:John.Doe@example.com");
            ParseUrl("news:comp.infosystems.www.servers.unix");
            ParseUrl("tel:+1-816-555-1212");
            ParseUrl("telnet://192.0.2.16:80/");
            ParseUrl("urn:oasis:names:specification:docbook:dtd:xml:4.1.2");
        }
    }
}
