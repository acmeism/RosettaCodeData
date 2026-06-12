using GLFW
using ModernGL
using LinearAlgebra
using Random

# global variables: the Ref variables contain data of fixed type, variable value """
const RAND_MAX = 0x7FFF
const angle = Ref{Float32}(0.0)
const r_mod = Ref{GLint}(-1)

""" make a rotation matrix """
function create_rotation_matrix(angle::Float32)
    # Simple rotation matrix around (angle*0.1, 1, 0)
    axis = normalize([angle * 0.1, 1.0, 0.0])
    c = cos(deg2rad(angle))
    s = sin(deg2rad(angle))
    t = 1 - c
    x, y, z = axis
    # Rotation matrix (Rodriguez formula)
    return Float32[
        t*x*x + c      t*x*y - s*z    t*x*z + s*y    0
        t*x*y + s*z    t*y*y + c      t*y*z - s*x    0
        t*x*z - s*y    t*y*z + s*x    t*z*z + c      0
        0              0              0              1
    ]
end

""" render the matrix """
function render(window::GLFW.Window, vao::GLuint, program::GLuint)
    glClear(GL_COLOR_BUFFER_BIT)
    glUniform1f(r_mod[], rand(Float32) / RAND_MAX)

    # Set up MVP matrix (simple orthographic projection and rotation)
    proj = Float32[
        1 0 0 0
        0 1 0 0
        0 0 1 0
        0 0 0 1
    ]
    rot = create_rotation_matrix(angle[])
    mvp = proj * rot
    mvp_loc = glGetUniformLocation(program, "mvp")
    glUniformMatrix4fv(mvp_loc, 1, GL_FALSE, mvp)

    glBindVertexArray(vao)
    glDrawArrays(GL_TRIANGLES, 0, 3)
    glBindVertexArray(0)

    angle[] += 0.02

    GLFW.SwapBuffers(window)
end

""" set up the shader, with random pixels """
function set_shader()
    # Vertex shader (modern GLSL)
    v = raw"""
        #version 330 core
        layout(location = 0) in vec3 position;
        uniform mat4 mvp;
        out float x, y, z;
        void main() {
            gl_Position = mvp * vec4(position, 1.0);
            x = gl_Position.x;
            y = gl_Position.y;
            z = gl_Position.z;
            x += y;
            y -= x;
            z += x - y;
        }
    """

    # Fragment shader
    f = raw"""
        #version 330 core
        in float x, y, z;
        uniform float r_mod;
        out vec4 FragColor;
        float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0); }
        void main() {
            FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);
        }
    """

    # Create and compile shaders
    vs = glCreateShader(GL_VERTEX_SHADER)
    ps = glCreateShader(GL_FRAGMENT_SHADER)

    # Convert strings to C-compatible format
    glShaderSource(vs, 1, [pointer(v)], C_NULL)
    glShaderSource(ps, 1, [pointer(f)], C_NULL)

    glCompileShader(vs)
    glCompileShader(ps)

    # Check shader compilation status with detailed error logging
    status = Ref{GLint}(0)
    glGetShaderiv(vs, GL_COMPILE_STATUS, status)
    if status[] == GL_FALSE
        log = Vector{UInt8}(undef, 512)
        glGetShaderInfoLog(vs, 512, C_NULL, log)
        error("Vertex shader compilation failed: ", String(log))
    end
    glGetShaderiv(ps, GL_COMPILE_STATUS, status)
    if status[] == GL_FALSE
        log = Vector{UInt8}(undef, 512)
        glGetShaderInfoLog(ps, 512, C_NULL, log)
        error("Fragment shader compilation failed: ", String(log))
    end

    # Create and link program
    program = glCreateProgram()
    glAttachShader(program, vs)
    glAttachShader(program, ps)
    glLinkProgram(program)

    glGetProgramiv(program, GL_LINK_STATUS, status)
    if status[] == GL_FALSE
        log = Vector{UInt8}(undef, 512)
        glGetProgramInfoLog(program, 512, C_NULL, log)
        error("Shader program linking failed: ", String(log))
    end

    glUseProgram(program)

    # Set global r_mod uniform location
    r_mod[] = glGetUniformLocation(program, "r_mod")

    return program, vs, ps
end

""" set up buffers for the graphics objects VAO and VBO """
function setup_buffers()
    # Triangle vertices
    vertices = Float32[
        -1.0, -0.5, 0.0,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
    ]

    # Create VAO and VBO
    vao = Ref{GLuint}(0)
    vbo = Ref{GLuint}(0)
    glGenVertexArrays(1, vao)
    glGenBuffers(1, vbo)

    glBindVertexArray(vao[])
    glBindBuffer(GL_ARRAY_BUFFER, vbo[])
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

    # Set vertex attribute pointers
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(Float32), C_NULL)
    glEnableVertexAttribArray(0)

    glBindBuffer(GL_ARRAY_BUFFER, 0)
    glBindVertexArray(0)

    return vao[], vbo[]
end

""" Make the GLFW window, run the GL program """
function main()
    # Initialize GLFW
    GLFW.Init()

    # Set GLFW window hints for OpenGL 3.3 core profile
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
    GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)
    GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
    GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE)

    # Create a window
    window = GLFW.CreateWindow(200, 200, "Stuff")
    if window == C_NULL
        GLFW.Terminate()
        error("Failed to create GLFW window")
    end

    # Make the window's context current
    GLFW.MakeContextCurrent(window)
    GLFW.SwapInterval(1)  # Enable vsync

    # Initialize shaders and buffers
    program, vs, ps = set_shader()
    vao, vbo = setup_buffers()

    # Main render loop
    while !GLFW.WindowShouldClose(window)
        render(window, vao, program)
        GLFW.PollEvents()
    end

    # Cleanup OpenGL resources
    glDeleteVertexArrays(1, [vao])
    glDeleteBuffers(1, [vbo])
    glDeleteShader(vs)
    glDeleteShader(ps)
    glDeleteProgram(program)

    # Cleanup GLFW
    GLFW.DestroyWindow(window)
    GLFW.Terminate()
end

# Run the program
main()
