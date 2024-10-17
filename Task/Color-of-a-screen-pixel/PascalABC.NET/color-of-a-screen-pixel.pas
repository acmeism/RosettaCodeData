##
uses GraphABC;

var curpos := System.Windows.Forms.Cursor.Position;
var apixel := new System.Drawing.Rectangle(curpos.X, curpos.Y, 1, 1);
var screenpixel := Picture.Create(apixel); //copy pixel from screen
Console.WriteLine(screenpixel.GetPixel(0, 0));
