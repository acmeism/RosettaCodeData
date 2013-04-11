use XUL::Gui;

display
    TextBox( id=>'txt', value=>'there have been no clicks yet' ),
    Button( label=>'click me', oncommand=>sub{
        $ID{txt}->value = ++$clicks
    });
