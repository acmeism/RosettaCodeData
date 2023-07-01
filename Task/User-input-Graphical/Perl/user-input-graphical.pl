use Wx;

package MyApp;
use base 'Wx::App';
use Wx qw(wxHORIZONTAL wxVERTICAL wxALL wxALIGN_CENTER);
use Wx::Event 'EVT_BUTTON';

our ($frame, $text_input, $integer_input);

sub OnInit
   {$frame = new Wx::Frame
       (undef, -1, 'Input window', [-1, -1], [250, 150]);

    my $panel = new Wx::Panel($frame, -1);
    $text_input = new Wx::TextCtrl($panel, -1, '');
    $integer_input = new Wx::SpinCtrl
       ($panel, -1, '', [-1, -1], [-1, -1],
        0, 0, 100_000);

    my $okay_button = new Wx::Button($panel, -1, 'OK');
    EVT_BUTTON($frame, $okay_button, \&OnQuit);

    my $sizer = new Wx::BoxSizer(wxVERTICAL);
    $sizer->Add($_, 0, wxALL | wxALIGN_CENTER, 5)
        foreach $text_input, $integer_input, $okay_button;
    $panel->SetSizer($sizer);

    $frame->Show(1);}

sub OnQuit
   {print 'String: ', $text_input->GetValue, "\n";
    print 'Integer: ', $integer_input->GetValue, "\n";
    $frame->Close;}

# ---------------------------------------------------------------

package main;

MyApp->new->MainLoop;
