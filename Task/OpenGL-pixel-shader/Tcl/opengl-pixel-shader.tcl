package require tcl3d

proc mkshader {type src} {
    set sh [glCreateShader $type]
    tcl3dOglShaderSource $sh $src
    glCompileShader $sh
    puts "compilation report : [tcl3dOglGetShaderState $sh $::GL_COMPILE_STATUS] [tcl3dOglGetShaderInfoLog $sh]"
    return $sh
}

proc render {{angle 0}} {
    glClear $::GL_COLOR_BUFFER_BIT
    glUniform1f $::uloc_rmod [expr {rand()}]
    glLoadIdentity
    glRotatef $angle 1.0 1.0 1.0
    glBegin GL_TRIANGLES
        glVertex3f -1 -.5 0
        glVertex3f  0  1  0
        glVertex3f  1  0  0
    glEnd

    .w swapbuffers
    after 40 [list render [expr {$angle+.2}]]
}

proc set_shader {} {
    set f {
        varying float x, y, z;
        uniform float rmod;
        float rand(float s, float r) { return mod(mod(s, r + rmod)*112341.0, 1.0); }
        void main() {
            gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1);
        }
    }
    set v {
        varying float x, y, z;
        void main() {
            gl_Position = ftransform();
            x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;
            x += y; y -= x; z += x - y;
        }
    }

    set vs [mkshader $::GL_VERTEX_SHADER $v]
    set ps [mkshader $::GL_FRAGMENT_SHADER $f]

    set proc [glCreateProgram]
    glAttachShader $proc $ps
    glAttachShader $proc $vs
    glLinkProgram $proc
    glUseProgram $proc

    set ::uloc_rmod [glGetUniformLocation $proc "rmod"]
}

togl .w -w 640 -h 480 -double true
pack .w -expand 1 -fill both
bind .w <Key-Escape> exit
wm protocol . WM_DELETE_WINDOW exit

set_shader
render
