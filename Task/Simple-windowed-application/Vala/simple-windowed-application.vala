// GTK 4
public class Example : Gtk.Application {
  public Example() {
    Object(application_id: "my.application",
      flags: ApplicationFlags.FLAGS_NONE);
    activate.connect(() => {
      var window = new Gtk.ApplicationWindow(this);
      var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 20);
      var label = new Gtk.Label("There have been no clicks yet");
      var button = new Gtk.Button.with_label("click me");
      var clicks = 0;
      button.clicked.connect(() => {
        clicks++;
        label.label = "Button clicked " + clicks.to_string() + " times";
      });
      box.append(label);
      box.append(button);
      window.set_child(box);
      window.present();
    });
  }
  public static int main(string[] argv) {
    return new Example().run(argv);
  }
}
