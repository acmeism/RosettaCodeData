use NativeCall;

class Window is repr('CPointer') {}
class Monitor is repr('CPointer') {}

# GLFW

constant $lib = ('glfw', v3);

sub glfwInit(--> int32) is native($lib) {*}
sub glfwCreateWindow(int32, int32, Str, Monitor, Window --> Window) is native($lib) {*}
sub glfwTerminate() is native($lib) {*}
sub glfwMakeContextCurrent(Window) is native($lib) {*}
sub glfwSetWindowShouldClose(Window, int32(Bool)) is native($lib) {*}
sub glfwWindowShouldClose(Window --> int32) is native($lib) {*}
sub glfwSwapBuffers(Window) is native($lib) {*}
sub glfwSwapInterval(int32) is native($lib) {*}
sub glfwPollEvents() is native($lib) {*}
sub glfwGetFramebufferSize(Window, int32 is rw, int32 is rw) is native($lib) {*}

# OpenGL

enum PrimitiveMode(
  GL_TRIANGLES =>	0x0004,
);

enum MatrixMode(
  GL_MATRIX_MODE => 0x0BA0,
  GL_MODELVIEW => 0x1700,
  GL_PROJECTION => 0x1701,
);

constant $gllib = 'GL';

sub glViewport(int32, int32, int32, int32) is native($gllib) {*}
sub glClear(int32) is native($gllib) {*}
sub glMatrixMode(int32) is native($gllib) {*}
sub glLoadIdentity() is native($gllib) {*}
sub glOrtho(num64, num64, num64, num64, num64, num64) is native($gllib) {*}
sub glRotatef(num32, num32, num32, num32) is native($gllib) {*}
sub glBegin(int32) is native($gllib) {*}
sub glColor3f(num32, num32, num32) is native($gllib) {*}
sub glVertex3f(num32, num32, num32) is native($gllib) {*}
sub glEnd() is native($gllib) {*}

constant GL_COLOR_BUFFER_BIT = 0x00004000;

die 'Failed to initialize GLFW' unless glfwInit().so;

my $w = glfwCreateWindow(640, 480, "OpenGL Triangle", Nil, Nil);
without $w { glfwTerminate(); die 'Failed to create window' }

glfwMakeContextCurrent($w);
glfwSwapInterval(1);

while not glfwWindowShouldClose($w) {
    my num32 $ratio;
    my int32 $width;
    my int32 $height;

    glfwGetFramebufferSize($w, $width, $height);
    $ratio = ($width / $height).Num;

    glViewport(0, 0, $width, $height);
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-$ratio, $ratio, -1e0, 1e0, 1e0, -1e0);
    glMatrixMode(GL_MODELVIEW);

    glLoadIdentity();
    glRotatef((now % 360 * 100e0) , 0e0, 0e0,  1e0);

    glBegin(GL_TRIANGLES);
    glColor3f(1e0, 0e0, 0e0);
    glVertex3f(5e-1, -2.88e-1, 0e0);
    glColor3f(0e0, 1e0, 0e0);
    glVertex3f(-5e-1, -2.88e-1, 0e0);
    glColor3f(0e0, 0e0, 1e0);
    glVertex3f( 0e0, 5.73e-1, 0e0);
    glEnd();

    glfwSwapBuffers($w);
    glfwPollEvents();
}

glfwTerminate();
