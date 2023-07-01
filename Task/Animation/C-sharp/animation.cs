using System;
using System.Drawing;
using System.Windows.Forms;

namespace BasicAnimation
{
  class BasicAnimationForm : Form
  {
    bool isReverseDirection;
    Label textLabel;
    Timer timer;

    internal BasicAnimationForm()
    {
      this.Size = new Size(150, 75);
      this.Text = "Basic Animation";

      textLabel = new Label();
      textLabel.Text = "Hello World! ";
      textLabel.Location = new Point(3,3);
      textLabel.AutoSize = true;
      textLabel.Click += new EventHandler(textLabel_OnClick);
      this.Controls.Add(textLabel);

      timer = new Timer();
      timer.Interval = 500;
      timer.Tick += new EventHandler(timer_OnTick);
      timer.Enabled = true;

      isReverseDirection = false;
    }

    private void timer_OnTick(object sender, EventArgs e)
    {
      string oldText = textLabel.Text, newText;
      if(isReverseDirection)
        newText = oldText.Substring(1, oldText.Length - 1) + oldText.Substring(0, 1);
      else
        newText = oldText.Substring(oldText.Length - 1, 1) + oldText.Substring(0, oldText.Length - 1);
      textLabel.Text = newText;
    }

    private void textLabel_OnClick(object sender, EventArgs e)
    {
      isReverseDirection = !isReverseDirection;
    }
  }

   class Program
   {
      static void Main()
      {
	Application.Run(new BasicAnimationForm());
      }
   }
}
