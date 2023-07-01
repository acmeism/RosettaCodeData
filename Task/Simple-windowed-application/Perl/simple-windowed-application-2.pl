use Gtk '-init';

# Window.
$window = Gtk::Window->new;
$window->signal_connect('destroy' => sub { Gtk->main_quit; });

# VBox.
$vbox = Gtk::VBox->new(0, 0);
$window->add($vbox);

# Label.
$label = Gtk::Label->new('There have been no clicks yet.');
$vbox->add($label);

# Button.
$count = 0;
$button = Gtk::Button->new(' Click Me ');
$vbox->add($button);
$button->signal_connect('clicked', sub {
  $label->set_text(++$count);
});

# Show.
$window->show_all;

# Main loop.
Gtk->main;
