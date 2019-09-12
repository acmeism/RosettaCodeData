  use Wx;

  $window = Wx::Frame->new(undef, -1, 'title');
  $window->Show;
  Wx::SimpleApp->new->MainLoop;
