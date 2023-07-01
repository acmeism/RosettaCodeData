import "ecere"

class GoodByeForm : Window
{
   text = "Goodbye, World!";
   size = { 320, 200 };
   hasClose = true;

   void OnRedraw(Surface surface)
   {
      surface.WriteTextf(10, 10, "Goodbye, World!");
   }
}

GoodByeForm form {};
