use strict;
use warnings;
use XUL::Gui;

display Button
    label => 'Goodbye, World!',
    oncommand => sub {quit};
