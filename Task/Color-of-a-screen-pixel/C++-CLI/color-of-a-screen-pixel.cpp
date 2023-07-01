using namespace System;
using namespace System::Drawing;
using namespace System::Windows::Forms;

[STAThreadAttribute]
int main()
{
	Point^ MousePoint = gcnew Point();
	Control^ TempControl = gcnew Control();
	MousePoint = TempControl->MousePosition;
	Bitmap^ TempBitmap = gcnew Bitmap(1,1);
	Graphics^ g = Graphics::FromImage(TempBitmap);	
	g->CopyFromScreen((Point)MousePoint, Point(0, 0), Size(1, 1));
	Color color = TempBitmap->GetPixel(0,0);
	Console::WriteLine("R: "+color.R.ToString());
	Console::WriteLine("G: "+color.G.ToString());
	Console::WriteLine("B: "+color.B.ToString());
}
