using System.Windows.Forms;

class RosettaForm : Form
{
    RosettaForm()
    {
        var clickCount = 0;

        var label = new Label();
        label.Text = "There have been no clicks yet.";
        label.Dock = DockStyle.Top;
        Controls.Add(label);

        var button = new Button();
        button.Text = "Click Me";
        button.Dock = DockStyle.Bottom;
        button.Click += delegate
                        {
                            clickCount++;
                            label.Text = "Number of clicks: " + clickCount + ".";
                        };
        Controls.Add(button);
    }

    static void Main()
    {
        Application.Run(new RosettaForm());
    }
}
