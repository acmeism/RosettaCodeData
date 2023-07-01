bool validate_input(Gtk.Window window, string str){
    int64 val;
    bool ret = int64.try_parse(str,out val);;

    if(!ret){
        var dialog = new Gtk.MessageDialog(window,
       	                                   Gtk.DialogFlags.MODAL,
       	                                   Gtk.MessageType.ERROR,
       	                                   Gtk.ButtonsType.OK,
       	                                   "Invalid value");
        dialog.run();
        dialog.destroy();
    }
    return ret;
}


int main (string[] args) {
    Gtk.init (ref args);

    var window = new Gtk.Window();
    window.title = "Rosetta Code";
    window.window_position = Gtk.WindowPosition.CENTER;
    window.destroy.connect(Gtk.main_quit);
    window.set_default_size(0,0);


    var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
    box.set_border_width(1);


    var label = new Gtk.Label ("Value:");


    var entry = new Gtk.Entry();
    entry.set_text("0");   //initialize to zero
    entry.activate.connect (() => {
        // read and validate the entered value
        validate_input(window, entry.get_text());
    });


    // button to increment
    var ib = new Gtk.Button.with_label("increment");
    ib.clicked.connect(() => {
        // read and validate the entered value
        var str = entry.get_text();
        if(validate_input(window, str)){
            entry.set_text((int.parse(str)+1).to_string());	
        }
    });


    // button to put in a random value if confirmed
    var rb = new Gtk.Button.with_label("random");
    rb.clicked.connect (() => {
        var dialog = new Gtk.MessageDialog(window,
        	                               Gtk.DialogFlags.MODAL,
        	                               Gtk.MessageType.QUESTION,
        	                               Gtk.ButtonsType.YES_NO,
        	                               "set random value");
        var answer = dialog.run();
        dialog.destroy();
        if(answer == Gtk.ResponseType.YES){
            entry.set_text(Random.int_range(0,10000).to_string());
        }
    });


    box.pack_start(label, false, false, 2);
    box.pack_start(entry, false, false, 2);
    box.pack_start(ib, false, false, 2);
    box.pack_start(rb, false, false, 2);

    window.add(box);

    window.show_all();

    Gtk.main ();
    return 0;
}
