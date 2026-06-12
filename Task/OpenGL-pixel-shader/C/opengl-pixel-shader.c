#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>
#include <GL/glut.h>

GLuint ps, vs, prog, r_mod;
float angle = 0;
void render(void)
{
	glClear(GL_COLOR_BUFFER_BIT);
	glUniform1f(r_mod, rand() / (float)RAND_MAX);

	glLoadIdentity();
	glRotatef(angle, angle * .1, 1, 0);
	glBegin(GL_TRIANGLES);
		glVertex3f(-1, -.5, 0);
		glVertex3f(0, 1, 0);
		glVertex3f(1, 0, 0);
	glEnd();
	angle += .02;
	glutSwapBuffers();
}

void set_shader()
{
	const char *f =
		"varying float x, y, z;"
		"uniform float r_mod;"
		"float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0); }"
		"void main() {"
		"	gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);"
		"}";
	const char *v =
		"varying float x, y, z;"
		"void main() {"
		"	gl_Position = ftransform();"
		"	x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;"
		"	x += y; y -= x; z += x - y;"
		"}";

	vs = glCreateShader(GL_VERTEX_SHADER);
	ps = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(ps, 1, &f, 0);
	glShaderSource(vs, 1, &v, 0);

	glCompileShader(vs);
	glCompileShader(ps);

	prog = glCreateProgram();
	glAttachShader(prog, ps);
	glAttachShader(prog, vs);

	glLinkProgram(prog);
	glUseProgram(prog);
	r_mod = glGetUniformLocation(prog, "r_mod");
}

int main(int argc, char **argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
	glutInitWindowSize(200, 200);
	glutCreateWindow("Stuff");
	glutIdleFunc(render);

	glewInit();
	if (!glewIsSupported("GL_VERSION_2_0")) {
		fprintf(stderr, "GL 2.0 unsupported\n");
		return 1;
	}

	set_shader();
	glutMainLoop();

	return 0;
}
