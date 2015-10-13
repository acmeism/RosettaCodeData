use GTK::Simple;

my GTK::Simple::App $app .= new(title => 'GUI component interaction');

$app.set_content(
    my $box = GTK::Simple::VBox.new(
        my $value     = GTK::Simple::Entry.new(text => '0'),
        my $increment = GTK::Simple::Button.new(label => 'Increment'),
        my $random    = GTK::Simple::Button.new(label => 'Random'),
    )
);

$app.size_request(400, 100);
$app.border_width = 20;
$box.spacing = 10;

$value.changed.tap: {
    ($value.text ||= '0') ~~ s:g/<-[0..9]>//;
}

$increment.clicked.tap: {
    $value.text += 1;
}

$random.clicked.tap: {
    # Dirty hack to work around the fact that GTK::Simple doesn't provide
    # access to GTK message dialogs yet :P
    if run «zenity --question --text "Reset to random value?"» {
        $value.text = (^100).pick;
    }
}

$app.run;
