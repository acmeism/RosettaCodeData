using Gtk;
using GtkSharp;

public class GoodbyeWorld {
  public static void Main(string[] args) {
    Gtk.Window window = new Gtk.Window();
    window.Title = "Goodbye, World";
    window.DeleteEvent += delegate { Application.Quit(); };
    window.ShowAll();
    Application.Run();
  }
}
