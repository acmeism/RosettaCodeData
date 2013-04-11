# Translated from http://www.mono-project.com/GtkSharp:_Hello_World

constant $GTK = "gtk-sharp,Version=2.12.0.0,Culture=neutral,PublicKeyToken=35e10195dab3c99f";

constant Application = CLR::("Gtk.Application,$GTK");
constant Window      = CLR::("Gtk.Window,$GTK");
constant Button      = CLR::("Gtk.Button,$GTK");

Application.Init;

# Set up a button object.
my $btn = Button.new("Goodbye, World!");
$btn.add_Clicked: sub ($obj, $args) { #OK
    # runs when the button is clicked.
    say "Goodbye, World!";
    Application.Quit;
};

my $window = Window.new("goodbyeworld");
$window.add_DeleteEvent: sub ($obj, $args) { #OK
    # runs when the user deletes the window using the "close
    # window" widget in the window frame.
    Application.Quit;
};

# Add the button to the window and display everything
$window.Add($btn);
$window.ShowAll;

Application.Run;
