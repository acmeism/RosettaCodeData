use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app .= new( title => 'Controls Enable / Disable' );

$app.set-content(
    my $box = GTK::Simple::HBox.new(
        my $inc   = GTK::Simple::Button.new( label => ' + ' ),
        my $value = GTK::Simple::Entry.new,
        my $dec   = GTK::Simple::Button.new( label => ' - ' )
    )
);

$app.border-width = 10;
$box.spacing = 10;

$value.changed.tap: {
    $value.text.=subst(/\D/, '');
    $inc.sensitive = $value.text < 10;
    $dec.sensitive = $value.text > 0;
}

$value.text = '0';

$inc.clicked.tap: { my $val = $value.text; $val += 1; $value.text = $val.Str }
$dec.clicked.tap: { my $val = $value.text; $val -= 1; $value.text = $val.Str }

$app.run;
