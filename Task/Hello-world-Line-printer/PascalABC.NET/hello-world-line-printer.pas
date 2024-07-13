{$reference 'System.Drawing.dll'}

uses System.Drawing;
uses System.Drawing.Printing;

begin
  var doc := new PrintDocument();
  doc.PrintPage += (s,e) -> begin
    e.Graphics.DrawString('Hello World!', new Font('Arial', 14), Brushes.Black, 0, 0);
  end;
  doc.Print;
end.
