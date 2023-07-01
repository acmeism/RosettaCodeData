module winapp ;
import dfl.all ;
import std.string ;

class MainForm: Form {
  Label label ;
  Button button ;
  this() {
    width = 240 ;
    with(label = new Label) {
      text = "There have been no clicks yet" ;
      dock = DockStyle.TOP ;
      parent = this ;
    }
    with(button = new Button) {
      dock = DockStyle.BOTTOM ;
      text = "Click Me" ;
      parent = this ;
      click ~= &onClickButton ;
    }
    height = label.height + button.height + 36 ;
  }
  private void onClickButton(Object sender, EventArgs ea) {
    static int count = 0 ;
    label.text = "You had been clicked me " ~ std.string.toString(++count) ~ " times." ;
  }
}

void main() {
    Application.run(new MainForm);
}
