# 20250206 Raku programming solution

use NativeCall;

class Window is repr('CPointer') {}
class Monitor is repr('CPointer') {}

constant $lib   = ('glfw', v3);
constant $gllib = 'GL';

sub glfwInit(--> int32) is native($lib) {*}
sub glfwCreateWindow(int32, int32, Str, Monitor, Window --> Window) is native($lib) {*}
sub glfwTerminate() is native($lib) {*}
sub glfwMakeContextCurrent(Window) is native($lib) {*}
sub glfwWindowShouldClose(Window --> int32) is native($lib) {*}
sub glfwSwapBuffers(Window) is native($lib) {*}
sub glfwSwapInterval(int32) is native($lib) {*}
sub glfwPollEvents() is native($lib) {*}

sub glClear(int32) is native($gllib) {*}
sub glLoadIdentity() is native($gllib) {*}
sub glTranslatef(num32, num32, num32) is native($gllib) {*}
sub glRotatef(num32, num32, num32, num32) is native($gllib) {*}
sub glColor4f(num32, num32, num32, num32) is native($gllib) {*}
sub glBegin(int32) is native($gllib) {*}
sub glVertex2f(num32, num32) is native($gllib) {*}
sub glEnd() is native($gllib) {*}
sub glPushMatrix() is native($gllib) {*}
sub glPopMatrix() is native($gllib) {*}

enum PrimitiveMode( GL_LINES => 0x0001 );
constant GL_COLOR_BUFFER_BIT = 0x00004000;

my (\NUM_LINES,\INNER_RADIUS,\OUTER_RADIUS,\ROTATION_SPEED) = 1, 0.0, 0.5, 2.0;

sub drawLine($angle, $opacity, $centerX, $centerY) {
   glPushMatrix();
   glTranslatef($centerX, $centerY, 0e0);
   glRotatef($angle, 0e0, 0e0, 1e0);
   glColor4f(1e0, 1e0, 1e0, $opacity);

   glBegin(GL_LINES);
      (INNER_RADIUS, OUTER_RADIUS)>>.Num.map: { glVertex2f($_, 0e0) };
   glEnd();

   glPopMatrix();
}

die 'Failed to initialize GLFW' unless glfwInit().so;

my $w = glfwCreateWindow(640, 480, "Spinners", Nil, Nil);
without $w { glfwTerminate(); die 'Failed to create window' }

glfwMakeContextCurrent($w);
glfwSwapInterval(1);

my @angles    = 0.0 xx 5;
my @positions = (<0 0>, <-.5 .5>, <.5 .5>, <-.5 -.5>, <.5 -.5>).map: *>>.Num;

until glfwWindowShouldClose($w) {
   glClear(GL_COLOR_BUFFER_BIT);
   glLoadIdentity();

   for 0 ..^ NUM_LINES -> $i {
      my $opacity = 1.0e0 - ($i / NUM_LINES);
      for @positions.kv -> $index, $pos {
         drawLine((@angles[$index] + 360 / NUM_LINES * $i).Num, $opacity, $pos[0], $pos[1]);
      }
   }

   glfwSwapBuffers($w);
   glfwPollEvents();

   for 0 ..^ 5 -> $i {
      @angles[$i] += (ROTATION_SPEED * (1 / 60).Num);
      @angles[$i] -= 360 if @angles[$i] >= 360;
   }
}

glfwTerminate();
