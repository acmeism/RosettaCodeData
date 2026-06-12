# 20210524 Raku programming solution

use NativeCall;

my $rot = 0e0;
                            # https://www.khronos.org/opengl/wiki/OpenGL_Type
enum GLenum (
   GL_SMOOTH   => 0x1D01,   GL_LIGHT0     => 0x4000,   GL_AMBIENT   => 0x1200,
   GL_DIFFUSE  => 0x1201,   GL_FRONT      => 0x0404,   GL_SHININESS => 0x1601,
   GL_LIGHTING => 0x0B50,   GL_DEPTH_TEST => 0x0B71,
);
enum GLbitfield ( GL_COLOR_BUFFER_BIT => 0x00004000,   GL_DEPTH_BUFFER_BIT => 0x00000100, );
enum GLUTdisplay_mode ( GLUT_RGB => 0x0000, GLUT_SINGLE => 0x0000, GLUT_DEPTH  => 0x0010, );


constant $lib = 'glut';
sub glutInit(CArray[uint32], CArray[Str]) is native($lib) {*};
sub glutInitDisplayMode(uint32 $mode) is native($lib) {*};
sub glutInitWindowSize(int32 $width, int32 $height) is native($lib) {*};
sub glutCreateWindow(Str $str) is native($lib) {*};
sub glutDisplayFunc(&func ()) is native($lib) {*};
sub glutWireTeapot(num64 $size) is native($lib) {*};
sub glutIdleFunc(&func ()) is native($lib) {*};
sub glutPostRedisplay() is native($lib) {*};
sub glutMainLoop() is native($lib) {*};


constant $gllib = 'GL';
sub glClearColor(num32 $red, num32 $green, num32 $blue, num32 $alpha) is native($gllib) {*};
sub glShadeModel(int32) is native($gllib) {*};
sub glEnable(int32) is native($gllib) {*};
sub glClear(int32) is native($gllib) {*};
sub glRotatef(num32 $angle, num32 $x, num32 $y, num32 $z) is native($gllib) {*};
sub glPushMatrix() is native($gllib) {*};
sub glPopMatrix() is native($gllib) {*};
sub glFlush() is native($gllib) {*};
sub glLightfv   (int32, int32, CArray[num32]) is native($gllib) {*};
sub glMaterialfv(int32, int32, CArray[num32]) is native($gllib) {*};


sub init {
   glClearColor(.5e0,.5e0,.5e0,0e0);
   glShadeModel(GL_SMOOTH);
   glLightfv(GL_LIGHT0,GL_AMBIENT,CArray[num32].new: 1e0,1e0,1e0,0e0); # white
   glLightfv(GL_LIGHT0,GL_DIFFUSE,CArray[num32].new: 1e0,1e0,1e0,0e0); # white
   glMaterialfv(GL_FRONT,GL_SHININESS,CArray[num32].new: 70e0); # skinless so no effect ?
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glEnable(GL_DEPTH_TEST);
}

sub display {
   glClear(GL_COLOR_BUFFER_BIT+|GL_DEPTH_BUFFER_BIT);
   glPushMatrix();
   glRotatef(30e0,1e0,1e0,0e0);
   glRotatef($rot,0e0,1e0,1e0);
   glMaterialfv(GL_FRONT,GL_DIFFUSE, CArray[num32].new: 0e0,1e0,0e0,0e0); # green
   glutWireTeapot(.5e0);
   glPopMatrix();
   glFlush();
}

sub onIdle {
   $rot += 0.1e0;       # changed from 0.01 for faster rotation rate
   glutPostRedisplay();
}


glutInit(CArray[uint32].new,CArray[Str].new);
glutInitDisplayMode(GLUT_SINGLE+|GLUT_RGB+|GLUT_DEPTH);
glutInitWindowSize(900,700);
glutCreateWindow("The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut.");
init();
glutDisplayFunc(&display);
glutIdleFunc(&onIdle);
glutMainLoop();
