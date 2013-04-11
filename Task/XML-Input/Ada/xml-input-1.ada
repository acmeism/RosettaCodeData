with Sax.Readers;
with Input_Sources.Strings;
with Unicode.CES.Utf8;
with My_Reader;

procedure Extract_Students is
   Sample_String : String :=
"<Students>" &
   "<Student Name=""April"" Gender=""F"" DateOfBirth=""1989-01-02"" />" &
   "<Student Name=""Bob"" Gender=""M"" DateOfBirth=""1990-03-04"" />" &
   "<Student Name=""Chad"" Gender=""M"" DateOfBirth=""1991-05-06"" />" &
   "<Student Name=""Dave"" Gender=""M"" DateOfBirth=""1992-07-08"">" &
      "<Pet Type=""dog"" Name=""Rover"" />" &
   "</Student>" &
   "<Student DateOfBirth=""1993-09-10"" Gender=""F"" Name=""&#x00C9;mily"" />" &
"</Students>";
   Reader : My_Reader.Reader;
   Input : Input_Sources.Strings.String_Input;
begin
   Input_Sources.Strings.Open (Sample_String, Unicode.CES.Utf8.Utf8_Encoding, Input);
   My_Reader.Parse (Reader, Input);
   Input_Sources.Strings.Close (Input);
end Extract_Students;
