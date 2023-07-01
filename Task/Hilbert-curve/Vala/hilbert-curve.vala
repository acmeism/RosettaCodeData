struct Point{
    int x;
    int y;
    Point(int px,int py){
        x=px;
        y=py;
    }
}

public class Hilbert : Gtk.DrawingArea {

    private int it = 1;
    private Point[] points;
    private const int WINSIZE = 300;

    public Hilbert() {
        set_size_request(WINSIZE, WINSIZE);
    }

    public void button_toggled_cb(Gtk.ToggleButton button){
        if(button.get_active()){
            it = int.parse(button.get_label());
            redraw_canvas();
        }
    }

    public override bool draw(Cairo.Context cr){
        int border_size = 20;
        int unit = (WINSIZE - 2 * border_size)/((1<<it)-1);

        //adjust border_size to center the drawing
        border_size = border_size + (WINSIZE - 2 * border_size - unit * ((1<<it)-1)) / 2;

        //white background
        cr.rectangle(0, 0, WINSIZE, WINSIZE);
        cr.set_source_rgb(1, 1, 1);
        cr.fill_preserve();
        cr.stroke();

        points = {};
        hilbert(0, 0, 1<<it, 0, 0);

        //magenta lines
        cr.set_source_rgb(1, 0, 1);

        // move to first point
        Point point = translate(border_size, WINSIZE, unit*points[0].x, unit*points[0].y);
        cr.move_to(point.x, point.y);

        foreach(Point i in points[1:points.length]){
            point = translate(border_size, WINSIZE, unit*i.x, unit*i.y);
            cr.line_to(point.x, point.y);
        }
        cr.stroke();
        return false;
    }

    private Point translate(int border_size, int size, int x, int y){
        return Point(border_size + x,size - border_size - y);
    }

    private void hilbert(int x, int y, int lg, int i1, int i2) {
        if (lg == 1) {
            points += Point(x,y);
            return;
        }
        lg >>= 1;
        hilbert(x+i1*lg,     y+i1*lg,     lg, i1,   1-i2);
        hilbert(x+i2*lg,     y+(1-i2)*lg, lg, i1,   i2);
        hilbert(x+(1-i1)*lg, y+(1-i1)*lg, lg, i1,   i2);
        hilbert(x+(1-i2)*lg, y+i2*lg,     lg, 1-i1, i2);
    }

    private void redraw_canvas(){
        var window = get_window();
        if (window == null)return;
        window.invalidate_region(window.get_clip_region(), true);
    }
}


int main(string[] args){
    Gtk.init (ref args);

    var window = new Gtk.Window();
    window.title = "Rosetta Code / Hilbert";
    window.window_position = Gtk.WindowPosition.CENTER;
    window.destroy.connect(Gtk.main_quit);
    window.set_resizable(false);

    var label = new Gtk.Label("Iterations:");

    // create radio buttons to select the number of iterations
    var rb1 = new Gtk.RadioButton(null);
    rb1.set_label("1");
    var rb2 = new Gtk.RadioButton.with_label_from_widget(rb1, "2");
    var rb3 = new Gtk.RadioButton.with_label_from_widget(rb1, "3");
    var rb4 = new Gtk.RadioButton.with_label_from_widget(rb1, "4");
    var rb5 = new Gtk.RadioButton.with_label_from_widget(rb1, "5");

    var hilbert = new Hilbert();

    rb1.toggled.connect(hilbert.button_toggled_cb);
    rb2.toggled.connect(hilbert.button_toggled_cb);
    rb3.toggled.connect(hilbert.button_toggled_cb);
    rb4.toggled.connect(hilbert.button_toggled_cb);
    rb5.toggled.connect(hilbert.button_toggled_cb);

    var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
    box.pack_start(label, false, false, 5);
    box.pack_start(rb1, false, false, 0);
    box.pack_start(rb2, false, false, 0);
    box.pack_start(rb3, false, false, 0);
    box.pack_start(rb4, false, false, 0);
    box.pack_start(rb5, false, false, 0);

    var grid = new Gtk.Grid();
    grid.attach(box, 0, 0, 1, 1);
    grid.attach(hilbert, 0, 1, 1, 1);
    grid.set_border_width(5);
    grid.set_row_spacing(5);

    window.add(grid);
    window.show_all();

    //initialise the drawing with iteration = 4
    rb4.set_active(true);

    Gtk.main();
    return 0;
}
