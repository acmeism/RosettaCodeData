program csv2html;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes;

const
  // Carriage Return/Line Feed
  CRLF    = #13#10;

  // The CSV data
  csvData =
  'Character,Speech'+CRLF+
  'The multitude,The messiah! Show us the messiah!'+CRLF+
  'Brians mother,<angry>Now you listen here! He''s not the messiah; he''s a very naughty boy! Now go away!</angry>'+CRLF+
  'The multitude,Who are you?'+CRLF+
  'Brians mother,I''m his mother; that''s who!'+CRLF+
  'The multitude,Behold his mother! Behold his mother!';

  // HTML header
  htmlHead =
  '<!DOCTYPE html'+CRLF+
  'PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"'+CRLF+
  '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'+CRLF+
  '<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">'+CRLF+
  '<head>'+CRLF+
  '<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />'+CRLF+
  '<title>CSV-to-HTML Conversion</title>'+CRLF+
  '<style type="text/css">'+CRLF+
  'body {font-family:verdana,helvetica,sans-serif;font-size:100%}'+CRLF+
  'table {width:70%;border:0;font-size:80%;margin:auto}'+CRLF+
  'th,td {padding:4px}'+CRLF+
  'th {text-align:left;background-color:#eee}'+CRLF+
  'th.c {width:15%}'+CRLF+
  'td.c {width:15%}'+CRLF+
  '</style>'+CRLF+
  '</head>'+CRLF+
  '<body>'+CRLF;

  // HTML footer
  htmlFoot =
  '</body>'+CRLF+
  '</html>';

{ Function to split a string into a list using a given delimiter }
procedure SplitString(S, Delim: string; Rslt: TStrings);
var
  i: integer;
  fld: string;
begin
  fld := '';

  for i := Length(S) downto 1 do
    begin
      if S[i] = Delim then
        begin
          Rslt.Insert(0,fld);
          fld := '';
        end
        else
         fld := S[i]+fld;
    end;

  if (fld <> '') then
      Rslt.Insert(0,fld);
end;

{ Simple CSV parser with option to specify that the first row is a header row }
procedure ParseCSV(const csvIn: string; htmlOut: TStrings; FirstRowIsHeader: Boolean = True);
const
  rowstart      = '<tr><td class="c">';
  rowend        = '</td></tr>';
  cellendstart  = '</td><td class="s">';
  hcellendstart = '</th><th class="s">';
  hrowstart     = '<tr><th class="c">';
  hrowend       = '</th></tr>';
var
  tmp,pieces: TStrings;
  i: Integer;
begin
  // HTML header
  htmlOut.Text := htmlHead + CRLF + CRLF;

  // Start the HTML table
  htmlOut.Text := htmlOut.Text + '<table summary="csv2table conversion">'  + CRLF;

  // Create stringlist
  tmp := TStringList.Create;
  try
    // Assign CSV data to stringlist and fix occurences of '<' and '>'
    tmp.Text := StringReplace(csvIn,'<','&lt;',[rfReplaceAll]);
    tmp.Text := StringReplace(tmp.Text,'>','&gt;',[rfReplaceAll]);

    // Create stringlist to hold the parts of the split data
    pieces := TStringList.Create;
    try

      // Loop through the CSV rows
      for i := 0 to Pred(tmp.Count) do
        begin
          // Split the current row
          SplitString(tmp[i],',',pieces);

          // Check if first row and FirstRowIsHeader flag set
          if (i = 0) and FirstRowIsHeader then

            // Render HTML
            htmlOut.Text := htmlOut.Text + hrowstart + pieces[0] + hcellendstart + pieces[1] + hrowend + CRLF
            else
            htmlOut.Text := htmlOut.Text + rowstart + pieces[0] + cellendstart + pieces[1] + rowend + CRLF;

        end;

      // Finish the HTML table and end the HTML page
      htmlOut.Text := htmlOut.Text + '</table>' + CRLF + htmlFoot;

    finally
      pieces.Free;
    end;

  finally
    tmp.Free;
  end;
end;

var
  HTML: TStrings;

begin
  // Create stringlist to hold HTML output
  HTML := TStringList.Create;
  try
    Writeln('Basic:');
    Writeln('');

    // Load and parse the CSV data
    ParseCSV(csvData,HTML,False);

    // Output the HTML to the console
    Writeln(HTML.Text);

    // Save the HTML to a file (in application's folder)
    HTML.SaveToFile('csv2html_basic.html');

    Writeln('');
    Writeln('=====================================');
    Writeln('');

    HTML.Clear;

    Writeln('Extra Credit:');
    Writeln('');

    // Load and parse the CSV data
    ParseCSV(csvData,HTML,True);

    // Output the HTML to the console
    Writeln(HTML.Text);

    // Save the HTML to a file (in application's folder)
    HTML.SaveToFile('csv2html_extra.html');
    Writeln('');
    Writeln('=====================================');

  finally
    HTML.Free;
  end;

  // Keep console window open
  Readln;
end.
