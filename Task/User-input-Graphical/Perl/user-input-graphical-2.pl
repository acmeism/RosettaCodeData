use XUL::Gui;

display Window
    title  => 'Input Window',
    width  => 250,
    height => 150,
    TextBox( id => 'txt' ),
    TextBox( id => 'num', type => 'number' ),
    Button(
        label => 'OK',
        oncommand => sub {
            print "String: " . ID(txt)->value . "\n"
                . "Number: " . ID(num)->value . "\n";
            quit;
        },
    );
