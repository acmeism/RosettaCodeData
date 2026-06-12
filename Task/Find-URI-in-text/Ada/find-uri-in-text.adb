with Ada.Exceptions;              use Ada.Exceptions;
with Ada.Text_IO;                 use Ada.Text_IO;
with Parsers.Multiline_Patterns;  use Parsers.Multiline_Patterns;
with Strings_Edit.Streams;        use Strings_Edit.Streams;
with Strings_Edit.UTF8.Maps;      use Strings_Edit.UTF8.Maps;

with Ada.Containers.Indefinite_Vectors;
with Parsers.Generic_Source.Patterns.Generic_Variable;
with Parsers.Multiline_Patterns;
with Parsers.Multiline_Source.Stream_IO;
with Strings_Edit.UTF8;

procedure Find_URI_In_Text is
   use Parsers.Multiline_Source;

   LF : constant Character := Character'Val (10);

   type Item (Length : Natural) is record
      IRI   : String (1..Length);
      Where : Location_Subtype;
   end record;
   package Item_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, Item);

   Found : Item_Vectors.Vector;

   procedure Add
             (  Value  : String;
                Where  : Location_Subtype;
                Append : Boolean
             )  is
   begin
      Found.Append ((Value'Length, Value, Where), 1);
   end Add;

   procedure Delete (Append : Boolean) is
   begin
      Found.Delete_Last;
   end Delete;

   function On_Line_Change
            (  Where : Location_Subtype
            )  return Result_Type is
   begin
      return Matched;
   end On_Line_Change;

   package Found_List is
      new Parsers.Multiline_Patterns.Generic_Variable;

   State : aliased Match_State (10_000);
   Data  : aliased String_Stream (2_000);
   Text  : Variable_Type;

   ALPHA  : constant Pattern_Type :=
      Any_Of ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
   unreserved : constant Pattern_Type :=
      ALPHA or Digit or Any_Of ("-._~");
   HEXDIG : constant Pattern_Type := Any_Of ("01234567889ABCDEFabcdef");
   sub_delims : constant Pattern_Type := Any_Of ("!$&'()*+,;=");
   IPvFuture : constant Pattern_Type :=
      "v" & HEXDIG & "." & (unreserved or sub_delims or ":");
   dec_octet : constant Pattern_Type :=
      Any_Of ("03456789")                       or
      "1" & (Digit & (Digit or Empty) or Empty) or
      "2" & Any_Of ("01234") & Digit            or
      "25" & Any_Of ("012345");
   IPv4address : constant Pattern_Type :=
      dec_octet & "." & dec_octet & "." & dec_octet & "." & dec_octet;
   h16  : constant Pattern_Type :=
      HEXDIG & (HEXDIG & (HEXDIG & (HEXDIG or Empty) or Empty) or Empty);
   h16x1 : constant Pattern_Type := h16 & ":";
   h16x2 : constant Pattern_Type := h16 & ":" & (h16x1 or Empty);
   h16x3 : constant Pattern_Type := h16 & ":" & (h16x2 or Empty);
   h16x4 : constant Pattern_Type := h16 & ":" & (h16x3 or Empty);
   h16x5 : constant Pattern_Type := h16 & ":" & (h16x4 or Empty);
   h16x6 : constant Pattern_Type := h16 & ":" & (h16x5 or Empty);
   Ls32 : constant Pattern_Type :=  h16 & ":" & h16 or IPv4address;
   IPv6address : constant Pattern_Type :=
                                      6 * (h16 & ":") & Ls32 or
                               "::" & 5 * (h16 & ":") & Ls32 or
      (        h16 or Empty) & "::" & 4 * (h16 & ":") & Ls32 or
      (h16x1 & h16 or Empty) & "::" & 3 * (h16 & ":") & Ls32 or
      (h16x2 & h16 or Empty) & "::" & 2 * (h16 & ":") & Ls32 or
      (h16x3 & h16 or Empty) & "::" &      h16 & ":"  & Ls32 or
      (h16x4 & h16 or Empty) & "::"                   & Ls32 or
      (h16x5 & h16 or Empty) & "::"                   & h16  or
      (h16x6 & h16 or Empty) & "::";
   IP_literal : constant Pattern_Type :=
       "[" & (IPv6address or IPvFuture) & "]";
   pct_Encoded : constant Pattern_Type :=
      "%" & HEXDIG & HEXDIG;
   ucschar : constant Pattern_Type :=
      Any_Of
      (  To_Set (   16#A0#,  16#D7FF#) or
         To_Set ( 16#F900#,  16#FDCF#) or
         To_Set ( 16#FDF0#,  16#FFEF#) or
         To_Set (16#10000#, 16#1FFFD#) or
         To_Set (16#20000#, 16#2FFFD#) or
         To_Set (16#30000#, 16#3FFFD#) or
         To_Set (16#40000#, 16#4FFFD#) or
         To_Set (16#50000#, 16#5FFFD#) or
         To_Set (16#60000#, 16#6FFFD#) or
         To_Set (16#70000#, 16#7FFFD#) or
         To_Set (16#80000#, 16#8FFFD#) or
         To_Set (16#90000#, 16#9FFFD#) or
         To_Set (16#A0000#, 16#AFFFD#) or
         To_Set (16#B0000#, 16#BFFFD#) or
         To_Set (16#C0000#, 16#CFFFD#) or
         To_Set (16#D0000#, 16#DFFFD#) or
         To_Set (16#E1000#, 16#EFFFD#)
      );
   iunreserved : constant Pattern_Type :=
      ALPHA or Digit or Any_Of ("-._~") or ucschar;
   ireg_name : constant Pattern_Type :=
      Proceed (iunreserved or pct_Encoded or sub_delims);
   iuserinfo : constant Pattern_Type :=
      Proceed (iunreserved or pct_Encoded or sub_delims or ":");
   ihost : constant Pattern_Type :=
      IP_literal or IPv4address or ireg_name;
   port : constant Pattern_Type := Natural_Number;
   iauthority : constant Pattern_Type :=
      Proceed (iuserinfo & "@") & ihost & (":" & port or Empty);
   scheme : constant Pattern_Type :=
      ALPHA & Proceed (ALPHA or Digit or Any_Of ("/-."));
   ipchar : constant Pattern_Type :=
      iunreserved or pct_Encoded or sub_delims or ":" or "@";
   isegment : constant Pattern_Type := Proceed (ipchar);
   isegment_nz : constant Pattern_Type := ipchar & Proceed (ipchar);
   ipath_abempty : constant Pattern_Type := Proceed ("/" & isegment);
   ipath_absolute : constant Pattern_Type :=
      "/" & (isegment_nz & Proceed ("/" & isegment) or Empty);
   ipath_rootless : constant Pattern_Type :=
      isegment_nz & Proceed ("/" & isegment);
   ipath_empty : constant Pattern_Type := Empty;
   ihier_part : constant Pattern_Type :=
      "//" & iauthority & ipath_abempty or
      ipath_absolute or ipath_rootless or ipath_empty;
   iprivate : constant Pattern_Type :=
      Any_Of
      (  To_Set (  16#E000#,   16#F8FF#) or
         To_Set ( 16#F0000#,  16#FFFFD#) or
         To_Set (16#100000#, 16#10FFFD#)
      );
   iquery : constant Pattern_Type :=
      Proceed (ipchar or iprivate or "/" or "?");
   ifragment : constant Pattern_Type := Proceed (ipchar or "/" or "?");
   IRI : constant Pattern_Type :=
      scheme & ":" & ihier_part &
      ("?" & iquery or Empty)  & ("#" & ifragment or Empty);
   Pattern : constant Pattern_Type :=
      Proceed (Found_List.Append (IRI) or Any or End_Of_Line & NL_Or_EOF);
begin
   Data.Set
   (  "this URI contains an illegal character, parentheses and a "
   &  "misplaced full stop:"                                        & LF
   &  "http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). "
   &  "(which is handled by http://mediawiki.org/)."                & LF
   &  "and another one just to confuse the parser: "
   &  "http://en.wikipedia.org/wiki/-)"                             & LF
   &   """)"" is handled the wrong way by the mediawiki parser."    & LF
   &  "ftp://domain.name/path(balanced_brackets)/foo.html"          & LF
   &  "ftp://domain.name/path(balanced_brackets)/ending.in.dot."    & LF
   &  "ftp://domain.name/path(unbalanced_brackets/ending.in.dot."   & LF
   &  "leading junk ftp://domain.name/path/embedded?punct/uation."  & LF
   &  "leading junk ftp://domain.name/dangling_close_paren)"        & LF
   &   "if you have other interesting URIs for testing, please "
   &   "add them here:"                                             & LF
   &   "http://www.example.org/D%C3%BCrst"                          & LF
   &   "1. An example of ftp: ftp://ftp.is.co.za/rfc/rfc1808.txt"   & LF
   &   "2. An example of http: http://www.ietf.org/rfc/rfc2396.txt" & LF
   &   "3. An example of ldap: "
   &   "ldap://[2001:db8::7]/c=GB?objectClass?one"                  & LF
   &   "4. An example of mailto: mailto:John.Doe@example.com"       & LF
   &   "5. An example of news: "
   &   "news:comp.infosystems.www.servers.unix"                     & LF
   &   "6. An example of tel: tel:+1-816-555-1212"                  & LF
   &   "7. An example of telnet: telnet://192.0.2.16:80"
   );

   declare
      Code    : aliased Stream_IO.Source (Data'Access);
      Result : constant Result_Type :=
                  Match (Pattern, Code'Access, State'Access);
      begin
         if Result.Outcome = Successful then
            for Index in 1.. Natural (Found.Length) loop
               Put_Line
               (  Found.Element (Index).IRI & " at " &
                  Image (Found.Element (Index).Where)
               );
            end loop;
         else
            raise Data_Error with "Failed to match";
         end if;
   end;
end Find_URI_In_Text;
