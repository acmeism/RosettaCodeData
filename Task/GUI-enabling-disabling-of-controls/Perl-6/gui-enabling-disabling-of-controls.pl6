use GTK::Simple;

my GTK::Simple::App $app .= new( title => 'Controls Enable \ Disable' );

$app.border_width = 20;

$app.set_content(
    GTK::Simple::HBox.new(
        my $inc   = GTK::Simple::Button.new( label => ' + ' ),
        my $value = GTK::Simple::Entry.new,
        my $dec   = GTK::Simple::Button.new( label => ' - ' )
    )
);

$value.changed.tap: {
    $value.text.=subst(/\D/, '');
    $inc.sensitive = $value.text < 10;
    $dec.sensitive = $value.text > 0;
}

$value.text = 0;

$inc.clicked.tap: { $value.text += 1 }
$dec.clicked.tap: { $value.text -= 1 }

$app.run;
