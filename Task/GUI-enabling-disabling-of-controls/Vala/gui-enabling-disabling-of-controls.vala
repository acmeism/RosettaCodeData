bool validate_input(Gtk.Window window, string str){
    int64 val;
    bool ret = int64.try_parse(str,out val);;

    if(!ret || str == ""){
        var dialog = new Gtk.MessageDialog(window,
                                           Gtk.DialogFlags.MODAL,
                                           Gtk.MessageType.ERROR,
                                           Gtk.ButtonsType.OK,
                                           "Invalid value");
        dialog.run();
        dialog.destroy();
    }
    if(str == ""){
        ret = false;
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

    var label = new Gtk.Label("Value:");
    var entry = new Gtk.Entry();
    var ib = new Gtk.Button.with_label("inc");
    var db = new Gtk.Button.with_label("dec");

    ib.set_sensitive(true);  //enable the inc button
    db.set_sensitive(false); //disable the dec button

    entry.set_text("0");   //initialize to zero

    entry.activate.connect(() => {
        var str = entry.get_text();

        if(!validate_input(window, str)){
            entry.set_text("0");   //initialize to zero on wrong input
        }else{
            int num = int.parse(str);
            if(num != 0){
                entry.set_sensitive(false); //disable the field
            }
            if(num > 0 && num < 10){
                ib.set_sensitive(true);   //enable the inc button
                db.set_sensitive(true);   //enable the dec button
            }
            if(num > 9){
                ib.set_sensitive(false);  //disable the inc button
                db.set_sensitive(true);   //enable the dec button
            }
        }
    });

    ib.clicked.connect(() => {
        // read and validate the entered value
        if(!validate_input(window, entry.get_text())){
            entry.set_text("0");   //initialize to zero on wrong input
        }else{
            int num = int.parse(entry.get_text()) + 1;
            entry.set_text(num.to_string());
            if(num > 9){
                ib.set_sensitive(false); //disable the inc button
            }
            if(num != 0){
                db.set_sensitive(true); //enable the dec button
                entry.set_sensitive(false); //disable the field
            }
            if(num == 0){
                entry.set_sensitive(true); //enable the field
            }
            if(num < 0){
                db.set_sensitive(false);   //disable the dec button
            }
        }
    });

    db.clicked.connect(() => {
        // read and validate the entered value
        int num = int.parse(entry.get_text()) - 1;
        entry.set_text(num.to_string());
        if(num == 0){
            db.set_sensitive(false); //disable the dec button
            entry.set_sensitive(true); //enable the field
        }
        if(num < 10){
            ib.set_sensitive(true); //enable the inc button
        }
    });

    box.pack_start(label, false, false, 2);
    box.pack_start(entry, false, false, 2);
    box.pack_start(ib, false, false, 2);
    box.pack_start(db, false, false, 2);

    window.add(box);

    window.show_all();

    Gtk.main();
    return 0;
}
