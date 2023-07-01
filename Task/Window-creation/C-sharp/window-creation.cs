using System;
using System.Windows.Forms;

public class Window {
    [STAThread]
    static void Main() {
        Form form = new Form();

        form.Text = "Window";
        form.Disposed += delegate { Application.Exit(); };

        form.Show();
        Application.Run();
    }
}
