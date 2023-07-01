#include<gl/freeglut.h>

double rot = 0;
float matCol[] = {1,0,0,0};

void display(){
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glPushMatrix();
	glRotatef(30,1,1,0);
	glRotatef(rot,0,1,1);
	glMaterialfv(GL_FRONT,GL_DIFFUSE,matCol);
	glutWireCube(1);
	glPopMatrix();
	glFlush();
}


void onIdle(){
	rot += 0.1;
	glutPostRedisplay();
}

void reshape(int w,int h){
	float ar = (float) w / (float) h ;
	
	glViewport(0,0,(GLsizei)w,(GLsizei)h);
	glTranslatef(0,0,-10);
	glMatrixMode(GL_PROJECTION);
	gluPerspective(70,(GLfloat)w/(GLfloat)h,1,12);
	glLoadIdentity();
	glFrustum ( -1.0, 1.0, -1.0, 1.0, 10.0, 100.0 ) ;
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void init(){
	float pos[] = {1,1,1,0};
	float white[] = {1,1,1,0};
	float shini[] = {70};
	
	glClearColor(.5,.5,.5,0);
	glShadeModel(GL_SMOOTH);
	glLightfv(GL_LIGHT0,GL_AMBIENT,white);
	glLightfv(GL_LIGHT0,GL_DIFFUSE,white);
	glMaterialfv(GL_FRONT,GL_SHININESS,shini);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_DEPTH_TEST);
}

int main(int argC, char* argV[])
{
	glutInit(&argC,argV);
	glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB|GLUT_DEPTH);
	glutInitWindowSize(600,500);
	glutCreateWindow("Rossetta's Rotating Cube");
	init();
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutIdleFunc(onIdle);
	glutMainLoop();
	return 0;
}
