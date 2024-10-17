program HTTP;

{$APPTYPE CONSOLE}

{$DEFINE DEBUG}

uses
  Classes,
  httpsend; // Synapse httpsend class

var
  Response: TStrings;
  HTTPObj: THTTPSend;

begin
  HTTPObj := THTTPSend.Create;
  try
    { Stringlist object to capture HTML returned
      from URL }
    Response := TStringList.Create;
    try
      if HTTPObj.HTTPMethod('GET','http://www.mgis.uk.com') then
        begin
          { Load HTTP Document into Stringlist }
          Response.LoadFromStream(HTTPObj.Document);
          { Write the response to the console window }
          Writeln(Response.Text);
        end
        else
        Writeln('Error retrieving data');

    finally
      Response.Free;
    end;

  finally
    HTTPObj.Free;
  end;

  // Keep console window open
  Readln;

end.
