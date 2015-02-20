use GTK::Simple;

my GTK::Simple::App $app .= new(title => 'Simple GTK Window');

$app.size_request(250, 100);

$app.set_content(
    GTK::Simple::VBox.new(
        my $button = GTK::Simple::Button.new(label => 'Exit'),
    )
);

$app.border_width = 40;

$button.clicked.tap: { $app.exit }

$app.run;
