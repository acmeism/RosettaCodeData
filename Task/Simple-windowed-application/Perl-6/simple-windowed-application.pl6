use GTK::Simple;

my GTK::Simple::App $app .= new(title => 'Simple Windowed Application');

$app.size_request(350, 100);

$app.set_content(
    GTK::Simple::VBox.new(
        my $label  = GTK::Simple::Label.new( text  => 'There have been no clicks yet'),
        my $button = GTK::Simple::Button.new(label => 'click me'),
    )
);

$app.border_width = 40;

$button.clicked.tap: {
    state $clicks += 1;
    $label.text = "There has been $clicks click{ 's' if $clicks != 1 }";
}

$app.run;
