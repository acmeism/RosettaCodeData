using System;
using System.ComponentModel;
using System.Windows.Forms;

class RosettaInteractionForm : Form
{
    // Model used for DataBinding.
    // Notifies bound controls about Value changes.
    class NumberModel: INotifyPropertyChanged
    {

        Random rnd = new Random();

        // initialize event with empty delegate to avoid checks on null
        public event PropertyChangedEventHandler PropertyChanged = delegate {};

        int _value;
        public int Value
        {
            get { return _value; }
            set
            {
                _value = value;
                // Notify bound control about value change
                PropertyChanged(this, new PropertyChangedEventArgs("Value"));
            }
        }

        public void ResetToRandom(){
            Value = rnd.Next(5000);
        }
    }

    NumberModel model = new NumberModel{ Value = 0};

    RosettaInteractionForm()
    {
        //MaskedTextBox is a TextBox variety with built-in input validation
        var tbNumber = new MaskedTextBox
                        {
                            Mask="0000",            // allow 4 decimal digits only
                            ResetOnSpace = false,   // don't enter spaces
                            Dock = DockStyle.Top    // place at the top of form
                        };
        // bound TextBox.Text to NumberModel.Value;
        tbNumber.DataBindings.Add("Text", model, "Value");

        var btIncrement = new Button{Text = "Increment", Dock = DockStyle.Bottom};
        btIncrement.Click += delegate
                        {
                            model.Value++;
                        };
        var btDecrement = new Button{Text = "Decrement", Dock = DockStyle.Bottom};
        btDecrement.Click += delegate
                        {
                            model.Value--;
                        };
        var btRandom = new Button{ Text="Reset to Random", Dock = DockStyle.Bottom };
        btRandom.Click += delegate
                        {
                            if (MessageBox.Show("Are you sure?", "Are you sure?", MessageBoxButtons.YesNo) == DialogResult.Yes)
                                model.ResetToRandom();
                        };
        Controls.Add(tbNumber);
        Controls.Add(btIncrement);
        Controls.Add(btDecrement);
        Controls.Add(btRandom);
    }
    static void Main()
    {
        Application.Run(new RosettaInteractionForm());
    }
}
