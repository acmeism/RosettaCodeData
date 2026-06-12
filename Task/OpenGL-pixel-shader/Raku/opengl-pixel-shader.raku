# 20250207 Raku programming solution

use NativeCall;

my ($angle, $r_mod) = 0e0;

# OpenGL and GLUT constants
enum GLenum ( GL_TRIANGLES => 0x0004);

enum GLbitfield ( GL_COLOR_BUFFER_BIT => 0x00004000, GL_DEPTH_BUFFER_BIT => 0x00000100 );
enum GLUTdisplay_mode ( GLUT_RGB => 0x0000, GLUT_DOUBLE => 0x0002, GLUT_DEPTH => 0x0010 );
enum Shader_type ( GL_FRAGMENT_SHADER => 0x8B30, GL_VERTEX_SHADER => 0x8B31 );
enum STDLIB ( RAND_MAX => 2147483647 );

# GLUT functions
constant $lib = 'glut';
sub glutInit(CArray[uint32], CArray[Str]) is native($lib) {*}
sub glutInitDisplayMode(uint32 $mode) is native($lib) {*}
sub glutInitWindowSize(int32 $width, int32 $height) is native($lib) {*}
sub glutCreateWindow(Str $str) is native($lib) {*}
sub glutDisplayFunc(&func ()) is native($lib) {*}
sub glutIdleFunc(&func ()) is native($lib) {*}
sub glutSwapBuffers() is native($lib) {*}
sub glutMainLoop() is native($lib) {*}

# OpenGL functions
constant $gllib = 'GL';
sub glClear(int32) is native($gllib) {*}
sub glLoadIdentity() is native($gllib) {*}
sub glRotatef(num32 $angle, num32 $x, num32 $y, num32 $z) is native($gllib) {*}
sub glBegin(uint32) is native($gllib) {*}
sub glEnd() is native($gllib) {*}
sub glVertex3f(num32 $x, num32 $y, num32 $z) is native($gllib) {*}
sub glUniform1f(uint32, num32) is native($gllib) {*}

# Shader functions
sub glCreateShader(uint32) returns uint32 is native($gllib) {*}
sub glShaderSource(uint32, int32, CArray[Str], CArray[int32]) is native($gllib) {*}
sub glCompileShader(uint32) is native($gllib) {*}
sub glCreateProgram() returns uint32 is native($gllib) {*}
sub glAttachShader(uint32, uint32) is native($gllib) {*}
sub glLinkProgram(uint32) is native($gllib) {*}
sub glUseProgram(uint32) is native($gllib) {*}
sub glGetUniformLocation(uint32, Str) returns uint32 is native($gllib) {*}

# GLEW functions
constant $glewlib = 'GLEW';
sub glewInit() returns int32 is native($glewlib) {*}
sub glewIsSupported(Str) returns int32 is native($glewlib) {*}

sub render() {
   glClear(GL_COLOR_BUFFER_BIT +| GL_DEPTH_BUFFER_BIT);
   glUniform1f($r_mod, rand / RAND_MAX);
   glLoadIdentity();
   glRotatef($angle, $angle * 0.1, 1e0, 0e0);
   glBegin(GL_TRIANGLES);
      glVertex3f(-1e0, -0.5e0, 0e0);
      glVertex3f(0e0, 1e0, 0e0);
      glVertex3f(1e0, 0e0, 0e0);
   glEnd();
   $angle += 0.02;
   glutSwapBuffers();
}

sub compile_shader($shader_type, $source) {
   my $shader = glCreateShader($shader_type);
   my $length = $source.chars;
   my $source_array = CArray[Str].new($source);
   my $length_array = CArray[int32].new($length);
   glShaderSource($shader, 1, $source_array, $length_array);
   glCompileShader($shader);
   return $shader;
}

sub set_shader() {
   my $f = q:to/END/;
varying float x, y, z;
uniform float r_mod;
float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0); }
void main() {
   gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);
}
END
   my $v = q:to/END/;
varying float x, y, z;
void main() {
   gl_Position = ftransform();
   x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;
   x += y; y -= x; z += x - y;
}
END

   my $vs = compile_shader(GL_VERTEX_SHADER, $v);
   my $ps = compile_shader(GL_FRAGMENT_SHADER, $f);

   given my $prog = glCreateProgram() {
      ($vs, $ps).map: -> $shader { glAttachShader($prog, $shader) };
      glLinkProgram($prog);
      glUseProgram($prog);
      $r_mod = glGetUniformLocation($prog, "r_mod");
   }
}

glutInit(CArray[uint32].new, CArray[Str].new);
glutInitDisplayMode(GLUT_DOUBLE +| GLUT_RGB +| GLUT_DEPTH);
glutInitWindowSize(600, 600);
glutCreateWindow("pixel shader");
glutDisplayFunc(&render);
glutIdleFunc(&render);
glewInit();
die "GL 2.0 unsupported\n" unless glewIsSupported("GL_VERSION_2_0");
set_shader();
glutMainLoop();
