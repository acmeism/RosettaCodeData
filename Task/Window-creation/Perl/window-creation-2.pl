  use SDL::App;
  use SDL::Event;

  $app = SDL::App->new;
  $app->loop({
    SDL_QUIT() => sub { exit 0; },
  });
