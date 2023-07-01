#! xbigforth
\ automatic generated code
\ do not edit

also editor also minos also forth

include triangle.fs
component class triangle
public:
  early widget
  early open
  early dialog
  early open-app
 ( [varstart] )  ( [varend] )
how:
  : open     new DF[ 0 ]DF s" Triangle" open-component ;
  : dialog   new DF[ 0 ]DF s" Triangle" open-dialog ;
  : open-app new DF[ 0 ]DF s" Triangle" open-application ;
class;

triangle implements
 ( [methodstart] )  ( [methodend] )
  : widget  ( [dumpstart] )
        GL[ ^ glcanvas with
0 0 w @ h @ glViewport
GL_PROJECTION glMatrixMode
glLoadIdentity
-30e 30e -30e 30e -30e 30e glOrtho
GL_MODELVIEW glMatrixMode
0.3e 0.3e 0.3e 0.0e glClearColor
GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT or glClear
GL_SMOOTH glShadeModel
glLoadIdentity
-15e -15e 0e glTranslatef
GL_TRIANGLES glBegin
1e 0e 0e glColor3f
0e 0e glVertex2f
0e 1e 0e glColor3f
30e 0e glVertex2f
0e 0e 1e glColor3f
0e 30e glVertex2f
glEnd
glFlush
endwith ]GL ( MINOS ) ^^ CK[ ( x y b n -- ) 2drop 2drop ]CK ( MINOS ) $280 $1 *hfil $1E0 $1 *vfil glcanvas new
      &1 vabox new
    ( [dumpend] ) ;
  : init  ^>^^  assign  widget 1 :: init ;
class;

: main
  triangle open-app
  $1 0 ?DO  stop  LOOP bye ;
script? [IF]  main  [THEN]
previous previous previous
