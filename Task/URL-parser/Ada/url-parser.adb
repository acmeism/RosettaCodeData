with Ada.Text_IO;

with AWS.URL;
with AWS.Parameters;
with AWS.Containers.Tables;

procedure URL_Parser is

   procedure Parse (URL : in String) is

      use AWS.URL, Ada.Text_IO;
      use AWS.Containers.Tables;

      procedure Put_Cond (Item     : in String;
                          Value    : in String;
                          When_Not : in String := "") is
      begin
         if Value /= When_Not then
            Put ("  ");  Put (Item);  Put_Line (Value);
         end if;
      end Put_Cond;

      Obj  : Object;
      List : Table_Type;
   begin
      Put_Line ("Parsing " & URL);

      Obj  := Parse (URL);
      List := Table_Type (AWS.Parameters.List'(AWS.URL.Parameters (Obj)));

      Put_Cond ("Scheme:    ", Protocol_Name (Obj));
      Put_Cond ("Domain:    ", Host     (Obj));
      Put_Cond ("Port:      ", Port     (Obj), When_Not => "0");
      Put_Cond ("Path:      ", Path     (Obj));
      Put_Cond ("File:      ", File     (Obj));
      Put_Cond ("Query:     ", Query    (Obj));
      Put_Cond ("Fragment:  ", Fragment (Obj));
      Put_Cond ("User:      ", User     (Obj));
      Put_Cond ("Password:  ", Password (Obj));

      if List.Count /= 0 then
         Put_Line ("  Parameters:");
      end if;
      for Index in 1 .. List.Count loop
         Put ("    "); Put (Get_Name  (List, N => Index));
         Put ("    "); Put ("'" & Get_Value (List, N => Index) & "'");
         New_Line;
      end loop;
      New_Line;
   end Parse;

begin
   Parse ("foo://example.com:8042/over/there?name=ferret#nose");
   Parse ("urn:example:animal:ferret:nose");
   Parse ("jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true");
   Parse ("ftp://ftp.is.co.za/rfc/rfc1808.txt");
   Parse ("http://www.ietf.org/rfc/rfc2396.txt#header1");
   Parse ("ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two");
   Parse ("mailto:John.Doe@example.com");
   Parse ("news:comp.infosystems.www.servers.unix");
   Parse ("tel:+1-816-555-1212");
   Parse ("telnet://192.0.2.16:80/");
   Parse ("urn:oasis:names:specification:docbook:dtd:xml:4.1.2");
   Parse ("ssh://alice@example.com");
   Parse ("https://bob:pass@example.com/place");
   Parse ("http://example.com/?a=1&b=2+2&c=3&c=4&d=%65%6e%63%6F%64%65%64");
end URL_Parser;
