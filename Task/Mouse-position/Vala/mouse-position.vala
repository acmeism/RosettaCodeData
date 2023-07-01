// GTK 4
public class Example : Gtk.Application {
  public Example() {
    Object(application_id: "my.application",
      flags: ApplicationFlags.FLAGS_NONE);
    activate.connect(() => {
      var window = new Gtk.ApplicationWindow(this);
      var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 20);
      var button = new Gtk.Button.with_label("Get Cursor Position");
      button.clicked.connect((a) => {
        double x, y;
        var device_pointer= window.get_display().get_default_seat().get_pointer();
        window.get_surface().get_device_position(device_pointer, out x, out y, null);
        label.set_text(x.to_string() + "," + y.to_string());
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
