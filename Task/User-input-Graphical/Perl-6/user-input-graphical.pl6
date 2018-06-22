use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app .= new( title => 'User Interaction' );

$app.border-width = 20;

$app.set-content(
    GTK::Simple::VBox.new(
        my $        = GTK::Simple::Label.new( text => 'Enter a string.' ),
        my $str     = GTK::Simple::Entry.new,
        my $string  = GTK::Simple::Label.new,
        my $        = GTK::Simple::Label.new( text => 'Enter the number 75000' ),
        my $val     = GTK::Simple::Entry.new,
        my $correct = GTK::Simple::Label.new,
    )
);

$str.changed.tap: {
    $string.text = "You entered: { $str.text }"
}

$val.changed.tap: {
    $correct.text = "That's { 'not' unless $val.text ~~ / ^^ <ws> 75000 <ws> $$ / } 75000!"
}

$app.run;
