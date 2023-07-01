public class Example: Gtk.Application {
  private Gtk.ApplicationWindow window;
  private Gtk.DrawingArea drawing_area;
  public Example() {
    Object(application_id: "my.application", flags: ApplicationFlags.FLAGS_NONE);
    this.activate.connect(() => {
      window = new Gtk.ApplicationWindow(this);
      drawing_area = new Gtk.DrawingArea();
      drawing_area.set_draw_func(draw_mandelbrot);
      window.set_child(drawing_area);
      window.present();
    });
  }

  private void draw_mandelbrot(Gtk.DrawingArea area, Cairo.Context cr, int width, int height) {
    cr.set_source_rgb(0, 0, 0);
    cr.paint();
    int x0 = -1;
    double x_increment = 2.47 / (float) width;
    double y_increment = 2.24 / (float) height;
    for (double x = -2.0; x < 0.47; x += x_increment, x0++) {
      int y0 = -1;
      for (double y = -1.12; y < 1.12; y += y_increment, y0++) {
        double c_re = x;
        double c_im = y;
        double x_ = 0,
        y_ = 0;
        int iterations = 0;
        int max_iterations = 50;
        while (iterations < max_iterations && x_ * x_ + y_ * y_ <= 4.0) {
          double x_new = x_ * x_ - y_ * y_ + c_re;
          y_ = 2.0 * x_ * y_ + c_im;
          x_ = x_new;
          iterations++;
        }
        if (iterations < max_iterations) {
          cr.set_source_rgb((float) iterations / (float) max_iterations, 0, 0);
          cr.rectangle(x0, y0, 1, 1);
          cr.fill();
        }
      }
    }
  }

  public static int main(string[] argv) {
    var app = new Example();
    return app.run(argv);
  }
}
