public class Example: Gtk.Application {
  private Gtk.ApplicationWindow window;
  private Gtk.DrawingArea drawing_area;
  public Example() {
    Object(application_id: "my.application", flags: ApplicationFlags.FLAGS_NONE);
    this.activate.connect(() => {
      window = new Gtk.ApplicationWindow(this);
      drawing_area = new Gtk.DrawingArea();
      drawing_area.set_draw_func(draw_circle);
      window.set_child(drawing_area);
      window.present();
    });
  }

  private void draw_circle(Gtk.DrawingArea area, Cairo.Context cr, int width, int height) {
    int centerx = width / 2;
    int centery = height / 2;
    double anglestep = 1.0 / width;
    for (float theta = (float) 0.0; theta < 360; theta += (float) 0.1) {
      float r;
      float g;
      float b;
      Gtk.hsv_to_rgb(theta / (float) 360.0, 1, 1, out r, out g, out b);
      cr.set_source_rgb(r, g, b);
      cr.line_to(centerx, centery);
      cr.arc(centerx, centery, ((double) width) / 2.2, GLib.Math.PI * 2 * theta / 360.0, anglestep);
      cr.line_to(centerx, centery);
      cr.stroke();
    }
  }

  public static int main(string[] argv) {
    var app = new Example();
    return app.run(argv);
  }
}
