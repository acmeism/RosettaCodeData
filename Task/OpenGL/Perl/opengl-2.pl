use SDL::App;
use SDL::Event;
use SDL::OpenGL;

$app = SDL::App->new(
  -gl => 1,
);

sub triangle {
  glBegin(GL_TRIANGLES);
  glColor(1.0, 0.0, 0.0);
  glVertex(5.0, 5.0);
  glColor(0.0, 1.0, 0.0);
  glVertex(25.0, 5.0);
  glColor(0.0, 0.0, 1.0);
  glVertex(5.0, 25.0);
  glEnd();
}

glMatrixMode(GL_PROJECTION);
glLoadIdentity();
gluOrtho2D(0.0, 30.0, 0.0, 30.0);
glMatrixMode(GL_MODELVIEW);
glClear(GL_COLOR_BUFFER_BIT);
triangle();
$app->sync;
$app->loop ({
  SDL_QUIT() => sub { exit; },
});
