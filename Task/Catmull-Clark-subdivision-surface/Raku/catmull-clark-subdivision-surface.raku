# 20260201 Raku programming solution

use NativeCall;

constant WIN-WIDTH  = 600;       # Window Width
constant WIN-HEIGHT = 600;       # Window Height
constant OBJ-SCALE  = 1.8e0;     # Scale factor
constant X-ROT-FREQ = 0.0006e0;  # X rotation frequency
enum GLbitfield
   ( GL_COLOR_BUFFER_BIT => 0x00004000, GL_DEPTH_BUFFER_BIT => 0x00000100 );
enum GLmatrix ( GL_MODELVIEW  => 0x1700, GL_PROJECTION => 0x1701 );
enum GLcap
   ( GL_DEPTH_TEST => 0x0B71, GL_LIGHTING => 0x0B50, GL_LIGHT0 => 0x4000 );
enum GLparam
   ( GL_DIFFUSE => 0x1201, GL_POSITION => 0x1203, GL_FRONT_AND_BACK => 0x0408 );
enum GLprimitive (  GL_LINES   => 0x0001, GL_POLYGON => 0x0009 );
enum GLmode ( GL_LINE => 0x1B01 );
enum GLattrib
   ( GL_POLYGON_BIT => 0x00000008, GL_LIGHTING_BIT => 0x00000040, GL_ENABLE_BIT => 0x00002000 );
enum GLUTstate ( GLUT_ELAPSED_TIME => 0x02BC );

# GLUT Bindings
constant $glutlib = 'glut';
sub glutInit(CArray[uint32], CArray[Str]) is native($glutlib) {*}
sub glutInitDisplayMode(uint32) is native($glutlib) {*}
sub glutInitWindowSize(int32, int32) is native($glutlib) {*}
sub glutCreateWindow(Str) is native($glutlib) {*}
sub glutDisplayFunc(&func ()) is native($glutlib) {*}
sub glutReshapeFunc(&func (int32, int32)) is native($glutlib) {*}
sub glutKeyboardFunc(&func (uint8, int32, int32)) is native($glutlib) {*}
sub glutIdleFunc(&func ()) is native($glutlib) {*}
sub glutSwapBuffers() is native($glutlib) {*}
sub glutMainLoop() is native($glutlib) {*}
sub glutPostRedisplay() is native($glutlib) {*}
sub glutGet(int32 --> int32) is native($glutlib) {*}

# OpenGL Bindings
constant $gllib = 'GL';
sub glClear(int32) is native($gllib) {*}
sub glClearColor(num32, num32, num32, num32) is native($gllib) {*}
sub glClearDepth(num64) is native($gllib) {*}
sub glEnable(int32) is native($gllib) {*}
sub glDisable(int32) is native($gllib) {*}
sub glViewport(int32, int32, int32, int32) is native($gllib) {*}
sub glMatrixMode(int32) is native($gllib) {*}
sub glLoadIdentity() is native($gllib) {*}
sub glBegin(int32) is native($gllib) {*}
sub glEnd() is native($gllib) {*}
sub glVertex3f(num32, num32, num32) is native($gllib) {*}
sub glVertex3fv(CArray[num32]) is native($gllib) {*}
sub glNormal3fv(CArray[num32]) is native($gllib) {*}
sub glColor3f(num32, num32, num32) is native($gllib) {*}
sub glPushAttrib(int32) is native($gllib) {*}
sub glPopAttrib() is native($gllib) {*}
sub glMaterialfv(int32, int32, CArray[num32]) is native($gllib) {*}
sub glLightfv(int32, int32, CArray[num32]) is native($gllib) {*}
sub glPolygonMode(int32, int32) is native($gllib) {*}
sub glFrustum(num64, num64, num64, num64, num64, num64) is native($gllib) {*}
sub glTranslatef(num32, num32, num32) is native($gllib) {*}
sub glRotatef(num32, num32, num32, num32) is native($gllib) {*}
sub glScalef(num32, num32, num32) is native($gllib) {*}

# Vector Math
class Vec3 { has num32 ($.x, $.y, $.z);
   method new(num32 $x = 0e0, num32 $y = 0e0, num32 $z = 0e0) {
      self.bless(:$x, :$y, :$z)
   }
   method copy()        { Vec3.new: $!x, $!y, $!z }
   method add(Vec3 $v)  { Vec3.new: $!x + $v.x, $!y + $v.y, $!z + $v.z }
   method sub(Vec3 $v)  { Vec3.new: $!x - $v.x, $!y - $v.y, $!z - $v.z }
   method mul(num32 $s) { Vec3.new: $!x * $s, $!y * $s, $!z * $s }
   method dot(Vec3 $v)  { $!x * $v.x + $!y * $v.y + $!z * $v.z }
   method len()         { sqrt(self.dot(self)).Num }
   method normalize() { do given self { .len > 0 ??  .mul(1e0/.len) !! .copy } }
   method cross(Vec3 $v) {
     Vec3.new: $!y*$v.z - $!z*$v.y, $!z*$v.x - $!x*$v.z, $!x*$v.y - $!y*$v.x
   }
   method to-array() { CArray[num32].new: $!x, $!y, $!z }
}

# Mesh Data Structures
class Vertex {
   has      (@.edges, @.faces) is rw;
   has Vec3 ($.pos, $.newpos)  is rw;
   method new(Vec3 :$pos!) { self.bless(:$pos, newpos => $pos.copy) }
}

class Face {
   has @.verts is rw;
   has Int $.fvert is rw;
}

class Edge { has Int ($.v0, $.v1, $.f0, $.f1, $.evert) is rw }

class Mesh { has (@.vertices, @.normals, @.faces);
   method add-vertex(Vec3 $v) { @!vertices.push($v) }
   method add-normal(Vec3 $n) { @!normals.push($n) }
   method add-face(@verts) { @!faces.push: Face.new(:verts(@verts),:fvert(-1)) }

   method compute-normals() {
      @!normals = Vec3.new xx @!vertices.elems;
      for @!faces -> $face {
         for ^$face.verts.elems -> \j {
            my $v0=@!vertices[$face.verts[j]];
            my $v1=@!vertices[$face.verts[(j+1) % +$face.verts]];
            my $v2=@!vertices[$face.verts[(j+ +$face.verts-1) % +$face.verts]];
            given $v1.sub($v0).cross($v2.sub($v0)) {
               @!normals[$face.verts[j]] .= add: $_
            }
         }
      }
      $_ .= normalize for @!normals
   }
}

# Subdivision
class SubdivMesh { has (@.verts, @.faces, @.edges);
   method find-edge(Int $v0, Int $v1) {
      for @!verts[$v0].edges -> $ei {
         my $e = @!edges[$ei];
         return $ei if $e.v0==$v0 && $e.v1==$v1 or $e.v0==$v1 && $e.v1==$v0
      }
      return -1;
   }

   method update-links() {
      for @!verts { ( .faces, .edges ) = | [] xx 2 }
      @!edges = [];
      for @!faces.kv -> $fi, $face {
         for ^$face.verts.elems -> $j {
            @!verts[ my $v0 = $face.verts[$j] ].faces.push: $fi;
            my $v1 = $face.verts[ ($j+1) % $face.verts.elems ];
            if ( my $ei = self.find-edge($v0, $v1) ) == -1 {
               @!edges.push: Edge.new( :v0($v0), :v1($v1),
                                       :f0($fi), :f1(-1),  :evert(-1));
               given $ei=+@!edges-1 { @!verts[$_].edges.push($ei) for $v0,$v1 }
            } else {
               @!edges[$ei].f1 = $fi
            }
         }
      }
   }

   method subdivide() {
      my ($V, $F, $E) = [ @!verts, @!faces, @!edges].map: *.elems;
      for @!faces -> $face { # Create face vertices
         my $p = Vec3.new;
         for $face.verts -> $vi { $p .= add: @!verts[$vi].pos }
         @!verts.push: Vertex.new(pos => $p.mul(1e0 / $face.verts.elems));
         $face.fvert = @!verts.elems - 1
      }
      for @!edges -> $edge { # Create edge vertices
         my $p = Vec3.new;
         $p .= add(@!verts[$edge.v0].pos);
         $p .= add(@!verts[$edge.v1].pos);
         $p .= add(@!verts[@!faces[$edge.f0].fvert].pos);
         $p .= add(@!verts[@!faces[$edge.f1].fvert].pos);
         @!verts.push: Vertex.new(pos => $p.mul(0.25e0));
         $edge.evert = @!verts.elems - 1
      }
      for ^$V -> $vi { # Update original vertices
         my $n    = (my $v = @!verts[$vi]).faces.elems;
         my ($newp,$p1) = $v.pos.mul(($n-2e0)/$n), Vec3.new;

         for $v.faces -> $fi { $p1 .= add(@!verts[@!faces[$fi].fvert].pos) }
         $newp .= add($p1.mul(1e0 / ($n * $n)));
         my $p2 = Vec3.new;
         for $v.edges -> $ei {
            given @!edges[$ei] { $p2 .= add(@!verts[.v0==$vi??.v1!!.v0].pos) }
         }
         $v.newpos = $newp .= add($p2.mul(1e0 / ($n * $n)))
      }
      for ^$V -> $vi { @!verts[$vi].pos = @!verts[$vi].newpos.copy }

      @!faces = gather for @!faces -> $face { # Create new faces
         for ^$face.verts.elems -> $j {
            my $v0 = $face.verts[($j-1+$face.verts.elems) % $face.verts.elems];
            my $v  = $face.verts[$j];
            my $v1 = $face.verts[($j + 1) % $face.verts.elems];
            my $e0 = @!edges[self.find-edge($v0, $v)];
            my $e1 = @!edges[self.find-edge($v, $v1)];
            take Face.new(:verts($e0.evert,$v,$e1.evert,$face.fvert),:fvert(-1))
         }
      }
      self.update-links();
   }

   method to-mesh() {
      my $mesh = Mesh.new;
      for @!verts -> $v    { $mesh.add-vertex($v.pos) }
      for @!faces -> $face { $mesh.add-face($face.verts) }
      $mesh.compute-normals;
      return $mesh
   }
}

sub load-cube() { # Load Cube OBJ
   my $mesh = Mesh.new;
   for (-1,-1,1,1,-1,1,-1,1,1,1,1,1,-1,1,-1,1,1,-1,-1,-1,-1,1,-1,-1).rotor(3) {
      $mesh.add-vertex(Vec3.new: | ($_ X* 0.5e0)) # 8 Corner vertices
   }
   for [0,1,3,2], [2,3,5,4], [4,5,7,6], [6,7,1,0], [1,7,5,3], [6,0,2,4] {
      $mesh.add-face: $_  # 6 Faces
   }
   $mesh.compute-normals;
   return $mesh
}

sub create-subdivision-levels(Mesh $base, Int $levels) {
   my @meshes = $base;
   my $sd     = SubdivMesh.new;

   for $base.vertices -> $v { $sd.verts.push(Vertex.new(pos => $v)) }
   for $base.faces -> $face {
      $sd.faces.push(Face.new(verts => $face.verts, fvert => -1))
   }
   $sd.update-links;
   return @meshes.append: ^($levels - 1) .map: {
      $sd.subdivide;
      $sd.to-mesh
   }
}

sub render-mesh(Mesh $mesh) {
   for $mesh.faces -> $face {
      glBegin(GL_POLYGON);
      for $face.verts -> $vi {
         glNormal3fv($mesh.normals[$vi].to-array);
         glVertex3fv($mesh.vertices[$vi].to-array);
      }
      glEnd
   }
}

sub draw-xyz() { # Draw XYZ Axis Lines
   glPushAttrib(GL_LIGHTING_BIT +| GL_ENABLE_BIT);
   glDisable(GL_LIGHTING);
   glBegin(GL_LINES);
   for (1e0,0e0,0e0), (0e0,1e0,0e0), (0e0,0e0,1e0) -> @color { # XYZ <-> RGB
      glColor3f(|@color);
      glVertex3f(0e0, 0e0, 0e0);
      glVertex3f(|@color)
   }
   glEnd;
   glPopAttrib
}

# Global State
my ( $auto-phase, $auto-dir, $auto-level, $cur-level, $y-rot, $x-rot ) =
               0,         1,           0,          0,    0e0,    0e0 ;
my ($wireframe, @meshes) = False;

sub display() {
   glClear(GL_COLOR_BUFFER_BIT +| GL_DEPTH_BUFFER_BIT);

   # Setup projection
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity;
   my ( $fovy, $near, $far,   $aspect ) =
        60e0,  0.1e0, 1000e0, WIN-WIDTH.Num / WIN-HEIGHT.Num ;
   my $top = $near * tan($fovy * pi / 360e0);
   glFrustum(-$top * $aspect, $top * $aspect, -$top, $top, $near, 1000e0);

   # Setup modelview
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity;

   # Headlamp Lighting
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glLightfv(GL_LIGHT0, GL_DIFFUSE, CArray[num32].new(1e0, 1e0, 1e0, 1e0));
   glLightfv(GL_LIGHT0, GL_POSITION, CArray[num32].new(0e0, 0e0, 0e0, 1e0));

   # Transformations
   glTranslatef(0e0, 0e0, -5e0); # Move back from camera
   glRotatef($x-rot, 1e0, 0e0, 0e0); # Rotate around X
   glRotatef($y-rot, 0e0, 1e0, 0e0); # Rotate around Y

   # Scale Object
   glScalef(OBJ-SCALE, OBJ-SCALE, OBJ-SCALE);

   # Render mesh
   glPushAttrib(GL_LIGHTING_BIT +| GL_POLYGON_BIT);
   glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, CArray[num32].new(1e0, 1e0, 1e0, 1e0));

   if $wireframe {
      glDisable(GL_LIGHTING);
      glColor3f(0e0, 1e0, 0e0);
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
   }
   render-mesh(@meshes[$cur-level]);
   glPopAttrib;
   draw-xyz();
   glutSwapBuffers;
}

sub reshape(int32 $w, int32 $h) {
   glViewport(0, 0, $w, $h);
   glClearDepth(1e0);
   glClearColor(0e0, 0e0, 0e0, 0e0);
   glEnable(GL_DEPTH_TEST)
}

sub keyboard(uint8 $key, int32 $x, int32 $y) {
   given $key.chr { when 'q' | 'Q' | "\x1b" { exit(0) } }  # q, Q, or Esc
}

sub auto-step() {
   return unless @meshes.Bool;
   ($wireframe, $cur-level) = ($auto-phase == 0), $auto-level;

   if $auto-dir > 0 {
      $auto-level >= @meshes.elems - 1 ?? ( $auto-dir = -1 ) !! $auto-level++
   } else {
      $auto-level <= 0 ?? (($auto-phase,$auto-dir) = ($auto-phase + 1) % 2, 1)
                       !! $auto-level--
   }
}

sub idle() {
   state ($last-ms, $last-auto-ms) = -1, -1;
   my $now = glutGet(GLUT_ELAPSED_TIME);
   if $last-ms < 0 { ($last-ms, $last-auto-ms) = $now xx 2 }

   given my $dt = ($now - $last-ms) / 1000e0 {
      $last-ms = $now;
      $y-rot += 35e0 * $dt;
      $x-rot  = 15e0 * sin($now * X-ROT-FREQ);
   }
   if ($now - $last-auto-ms) >= 500 {
      auto-step();
      $last-auto-ms = $now;
   }
   glutPostRedisplay
}

# Main
glutInit(CArray[uint32].new, CArray[Str].new);
glutInitDisplayMode(0x0000 +| 0x0002 +| 0x0010);
glutInitWindowSize(WIN-WIDTH, WIN-HEIGHT);
glutCreateWindow("Catmull-Clark (Raku)");
glutReshapeFunc(&reshape);
glutDisplayFunc(&display);
glutKeyboardFunc(&keyboard);
glutIdleFunc(&idle);

say "Generating meshes...";
@meshes = create-subdivision-levels(load-cube(), 5);
say "Starting loop.\nPress <q>, <Q> or <Esc> to quit.";

glutMainLoop;
