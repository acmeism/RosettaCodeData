using System;
using System.ComponentModel;
using System.Windows.Forms;

class RosettaInteractionForm : Form
{

    // Model used for DataBinding.
    // Notifies bound controls about Value changes.
    class NumberModel: INotifyPropertyChanged
    {
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
        var enabledIfZero = new Binding("Enabled", model, "Value");
        EnableControlWhen(tbNumber, value => value == 0);

        var btIncrement = new Button{Text = "Increment", Dock = DockStyle.Bottom};
        btIncrement.Click += delegate
                        {
                            model.Value++;
                        };
        EnableControlWhen(btIncrement, value => value < 10);
        var btDecrement = new Button{Text = "Decrement", Dock = DockStyle.Bottom};
        btDecrement.Click += delegate
                        {
                            model.Value--;
                        };
        EnableControlWhen(btDecrement, value => value > 0);
        Controls.Add(tbNumber);
        Controls.Add(btIncrement);
        Controls.Add(btDecrement);
    }

    // common part of creating bindings for Enabled property
    void EnableControlWhen(Control ctrl, Func<int, bool> predicate)
    {
        // bind Control.Enabled to NumberModel.Value
        var enabledBinding = new Binding("Enabled", model, "Value");
        // Format event is called when model value should be converted to Control value.
        enabledBinding.Format += (sender, args) =>
            {
                // Enabled property is of bool type.
                if (args.DesiredType != typeof(bool)) return;
                // set resulting value by applying condition
                args.Value = predicate((int)args.Value);
            };
        // as a result, control will be enabled if predicate returns true
        ctrl.DataBindings.Add(enabledBinding);
    }

    static void Main()
    {
        Application.Run(new RosettaInteractionForm());
    }
}
