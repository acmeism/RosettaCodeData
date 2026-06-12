#include<gl/freeglut.h>

double rot = 0;
float matCol[] = {1,0,0,0};

void display(){
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glPushMatrix();
	glRotatef(30,1,1,0);
	glRotatef(rot,0,1,1);
	glMaterialfv(GL_FRONT,GL_DIFFUSE,matCol);
	glutWireTeapot(0.5);
	glPopMatrix();
	glFlush();
}


void onIdle(){
	rot += 0.01;
	glutPostRedisplay();
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
	glutInitWindowSize(900,700);
	glutCreateWindow("The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut.");
	init();
	glutDisplayFunc(display);
	glutIdleFunc(onIdle);
	glutMainLoop();
	return 0;
}
