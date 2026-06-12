# 20260501 Raku programming solution

use NativeCall;

my (\GL_COLOR_BUFFER_BIT, \GL_DEPTH_BUFFER_BIT, \GL_TRIANGLE_STRIP) =
              0x00004000,           0x00000100,             0x0005;
my (\GLUT_SINGLE, \GLUT_RGB, \GLUT_DEPTH) = 0x0000, 0x0000, 0x0010;
my (\GL_LIGHTING, \GL_LIGHT0, \GL_NORMALIZE, \GL_DEPTH_TEST) =
          0x0B50,     0x4000,        0x0BA1,         0x0B71;
my (\GL_COLOR_MATERIAL, \GL_FRONT_AND_BACK, \GL_AMBIENT_AND_DIFFUSE) =
                0x0B57,             0x0408,                  0x1602;
my (\GL_LIGHT_MODEL_TWO_SIDE, \GL_SMOOTH) = 0x0B52, 0x1D01;
my (\GL_POSITION, \GL_AMBIENT, \GL_DIFFUSE, \GL_SPECULAR, \GL_SHININESS) =
          0x1203,      0x1200,      0x1201,       0x1202,        0x1601;

sub glClearColor(num32, num32, num32, num32) is native('GL') { * }
sub glClear(uint32)                          is native('GL') { * }
sub glBegin(uint32)                          is native('GL') { * }
sub glEnd()                                  is native('GL') { * }
sub glVertex3f(num32, num32, num32)          is native('GL') { * }
sub glNormal3f(num32, num32, num32)          is native('GL') { * }
sub glColor3f(num32, num32, num32)           is native('GL') { * }
sub glEnable(uint32)                         is native('GL') { * }
sub glLightfv(uint32, uint32, CArray[num32]) is native('GL') { * }
sub glFlush()                                is native('GL') { * }
sub glShadeModel(uint32)                     is native('GL') { * }
sub glTranslatef(num32, num32, num32)        is native('GL') { * }

sub glMaterialfv(uint32, uint32, CArray[num32]) is native('GL') { * }
sub glMaterialf(uint32, uint32, num32)          is native('GL') { * }
sub glColorMaterial(uint32, uint32)             is native('GL') { * }
sub glLightModeli(uint32, int32)                is native('GL') { * }
sub glRotatef(num32, num32, num32, num32)       is native('GL') { * }

sub glutInit(CArray[int32], CArray[Str])  is native('glut') { * }
sub glutInitDisplayMode(uint32)           is native('glut') { * }
sub glutInitWindowSize(int32, int32)      is native('glut') { * }
sub glutInitWindowPosition(int32, int32)  is native('glut') { * }
sub glutCreateWindow(Str --> int32)       is native('glut') { * }
sub glutDisplayFunc(&cb ())               is native('glut') { * }
sub glutMainLoop()                        is native('glut') { * }

sub mobius-point(num64 $t, num64 $r) {
   return ( cos($t) * (2e0 + ($r / 2e0) * cos($t / 2e0)) ,
            sin($t) * (2e0 + ($r / 2e0) * cos($t / 2e0)) ,
            ($r / 2e0) * sin($t / 2e0)                   )  X/ 2.5e0
}

sub mobius-normal(num64 $t, num64 $r) {
   my num64 ($dt, $dr) = 1e-4 xx 2;
   my @p  = mobius-point($t, $r);
   my @tv = mobius-point($t + $dt, $r) Z- @p;
   my @rv = mobius-point($t, $r + $dr) Z- @p;
   my @n = (@tv.rotate(1) Z* @rv.rotate(2)) Z- (@tv.rotate(2) Z* @rv.rotate(1));
   return @n X/ ( sqrt([+] @n »**» 2) || 1e0 )
}

sub display() {
   glClearColor(0e0, 0e0, 0e0, 1e0);
   glClear(GL_COLOR_BUFFER_BIT +| GL_DEPTH_BUFFER_BIT);
   glColor3f(0.13e0, 0.55e0, 0.13e0);
   my num64 ($t,$dt,$dr) = 0e0, 0.04e0, 0.04e0 ;

   loop (; $t <= 2e0*pi + $dt ; $t += $dt) {
      glBegin(GL_TRIANGLE_STRIP);
      loop (my num64 $r = -1e0; $r <= 1.01e0; $r += $dr) {
         for 0, $dt -> $off {
            glNormal3f(|mobius-normal($t + $off, $r));
            glVertex3f(|mobius-point($t + $off, $r))
         }
      }
      glEnd()
   }
   glFlush()
}

sub MAIN() {
   glutInit(CArray[int32].new, CArray[Str].new);
   glutInitDisplayMode(GLUT_SINGLE +| GLUT_RGB +| GLUT_DEPTH);
   glutInitWindowSize(1000, 1000);
   glutCreateWindow('');
   glEnable $_ for GL_DEPTH_TEST, GL_LIGHTING, GL_LIGHT0, GL_NORMALIZE;
   glShadeModel(GL_SMOOTH);

   my $white = CArray[num32].new(1e0, 1e0, 1e0, 1e0);
   my $dim   = CArray[num32].new(0.1e0, 0.1e0, 0.1e0, 1e0);
   my $pos   = CArray[num32].new(2e0, 2e0, 5e0, 1e0); # Light position

   glLightfv(GL_LIGHT0, GL_POSITION, $pos);
   glLightfv(GL_LIGHT0, GL_SPECULAR, $white);
   glLightfv(GL_LIGHT0, GL_DIFFUSE,  $white);
   glLightfv(GL_LIGHT0, GL_AMBIENT,  $dim);

   glEnable(GL_COLOR_MATERIAL);
   glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
   glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, $white);
   glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 60e0);
   glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, 1);

   glTranslatef(-0.07e0, 0.08e0, 0e0);
   glRotatef |$_ for [65e0, 1e0, 0e0, 0e0], [30e0, 0e0, 0e0, 1e0];

   glutDisplayFunc(&display);
   glutMainLoop()
}
