/* WebGL_rotating_F.wren */

import "./math" for Math

var GL_ARRAY_BUFFER     = 0x8892
var GL_STATIC_DRAW      = 0x88E4
var GL_VERTEX_SHADER    = 0x8B31
var GL_FRAGMENT_SHADER  = 0x8B30
var GL_COLOR_BUFFER_BIT = 0x4000
var GL_DEPTH_BUFFER_BIT = 0x0100
var GL_CULL_FACE        = 0x0B44
var GL_DEPTH_TEST       = 0x0B71
var GL_UNSIGNED_BYTE    = 0x1403
var GL_FLOAT            = 0x1406
var GL_TRIANGLES        = 0x0004

var GLUT_ACTION_ON_WINDOW_CLOSE = 0x01F9
var GLUT_ACTION_GLUTMAINLOOP_RETURNS = 0x0001
var GLUT_SINGLE = 0x0000
var GLUT_RGB    = 0x0000
var GLUT_DEPTH  = 0x0010

class Gl {
    foreign static bufferData(target, size, data, usage)
    foreign static createShader(type)
    foreign static shaderSource(shader, count, string, length)
    foreign static compileShader(shader)
    foreign static createProgram()
    foreign static attachShader(program, shader)
    foreign static linkProgram(program)
    foreign static getAttribLocation(program, name)
    foreign static getUniformLocation(program, name)
    foreign static genBuffers(n, buffers)
    foreign static bindBuffer(target, buffer)
    foreign static viewport(x, y, width, height)
    foreign static clear(mask)
    foreign static enable(cap)
    foreign static useProgram(program)
    foreign static drawArrays(mode, first, count)
    foreign static enableVertexAttribArray(index)
    foreign static vertexAttribPtr(index, size, type, normalized, stride, ptr)
    foreign static uniformMatrix4fv(location, count, transpose, value)
    foreign static flush()
}

class Glut {
    foreign static initDisplayMode(mode)
    foreign static initWindowSize(width, height)
    foreign static createWindow(name)
    foreign static setOption(eWhat, value)
}

class M4 {
    static perspective(fieldOfViewInRadians, aspect, near, far, dst) {
        if (!dst) dst = List.filled(16, 0)

        var f = (Num.pi * 0.5 - 0.5 * fieldOfViewInRadians).tan
        var rangeInv = 1 / (near - far)

        dst[ 0] = f / aspect
        dst[ 1] = 0
        dst[ 2] = 0
        dst[ 3] = 0
        dst[ 4] = 0
        dst[ 5] = f
        dst[ 6] = 0
        dst[ 7] = 0
        dst[ 8] = 0
        dst[ 9] = 0
        dst[10] = (near + far) * rangeInv
        dst[11] = -1
        dst[12] = 0
        dst[13] = 0
        dst[14] = near * far * rangeInv * 2
        dst[15] = 0

        return dst
    }

    static translate(m, tx, ty, tz, dst) {
        if (!dst) dst = List.filled(16, 0)

        var m00 = m[0]
        var m01 = m[1]
        var m02 = m[2]
        var m03 = m[3]
        var m10 = m[1 * 4 + 0]
        var m11 = m[1 * 4 + 1]
        var m12 = m[1 * 4 + 2]
        var m13 = m[1 * 4 + 3]
        var m20 = m[2 * 4 + 0]
        var m21 = m[2 * 4 + 1]
        var m22 = m[2 * 4 + 2]
        var m23 = m[2 * 4 + 3]
        var m30 = m[3 * 4 + 0]
        var m31 = m[3 * 4 + 1]
        var m32 = m[3 * 4 + 2]
        var m33 = m[3 * 4 + 3]

        if (m != dst) {
            dst[ 0] = m00
            dst[ 1] = m01
            dst[ 2] = m02
            dst[ 3] = m03
            dst[ 4] = m10
            dst[ 5] = m11
            dst[ 6] = m12
            dst[ 7] = m13
            dst[ 8] = m20
            dst[ 9] = m21
            dst[10] = m22
            dst[11] = m23
        }

        dst[12] = m00 * tx + m10 * ty + m20 * tz + m30
        dst[13] = m01 * tx + m11 * ty + m21 * tz + m31
        dst[14] = m02 * tx + m12 * ty + m22 * tz + m32
        dst[15] = m03 * tx + m13 * ty + m23 * tz + m33

        return dst
    }

    static xRotate(m, angleInRadians, dst) {
        if (!dst) dst = List.filled(16, 0)

        var m10 = m[4]
        var m11 = m[5]
        var m12 = m[6]
        var m13 = m[7]
        var m20 = m[8]
        var m21 = m[9]
        var m22 = m[10]
        var m23 = m[11]
        var c = angleInRadians.cos
        var s = angleInRadians.sin

        dst[4]  = c * m10 + s * m20
        dst[5]  = c * m11 + s * m21
        dst[6]  = c * m12 + s * m22
        dst[7]  = c * m13 + s * m23
        dst[8]  = c * m20 - s * m10
        dst[9]  = c * m21 - s * m11
        dst[10] = c * m22 - s * m12
        dst[11] = c * m23 - s * m13

        if (m != dst) {
            dst[ 0] = m[ 0]
            dst[ 1] = m[ 1]
            dst[ 2] = m[ 2]
            dst[ 3] = m[ 3]
            dst[12] = m[12]
            dst[13] = m[13]
            dst[14] = m[14]
            dst[15] = m[15]
        }

        return dst
    }

    static yRotate(m, angleInRadians, dst) {
        if (!dst) dst = List.filled(16, 0)

        var m00 = m[0 * 4 + 0]
        var m01 = m[0 * 4 + 1]
        var m02 = m[0 * 4 + 2]
        var m03 = m[0 * 4 + 3]
        var m20 = m[2 * 4 + 0]
        var m21 = m[2 * 4 + 1]
        var m22 = m[2 * 4 + 2]
        var m23 = m[2 * 4 + 3]
        var c = angleInRadians.cos
        var s = angleInRadians.sin

        dst[ 0] = c * m00 - s * m20
        dst[ 1] = c * m01 - s * m21
        dst[ 2] = c * m02 - s * m22
        dst[ 3] = c * m03 - s * m23
        dst[ 8] = c * m20 + s * m00
        dst[ 9] = c * m21 + s * m01
        dst[10] = c * m22 + s * m02
        dst[11] = c * m23 + s * m03

        if (m != dst) {
            dst[ 4] = m[ 4]
            dst[ 5] = m[ 5]
            dst[ 6] = m[ 6]
            dst[ 7] = m[ 7]
            dst[12] = m[12]
            dst[13] = m[13]
            dst[14] = m[14]
            dst[15] = m[15]
        }

        return dst
    }

    static zRotate(m, angleInRadians, dst) {
        if (!dst) dst = List.filled(16, 0)

        var m00 = m[0 * 4 + 0]
        var m01 = m[0 * 4 + 1]
        var m02 = m[0 * 4 + 2]
        var m03 = m[0 * 4 + 3]
        var m10 = m[1 * 4 + 0]
        var m11 = m[1 * 4 + 1]
        var m12 = m[1 * 4 + 2]
        var m13 = m[1 * 4 + 3]
        var c = angleInRadians.cos
        var s = angleInRadians.sin

        dst[ 0] = c * m00 + s * m10
        dst[ 1] = c * m01 + s * m11
        dst[ 2] = c * m02 + s * m12
        dst[ 3] = c * m03 + s * m13
        dst[ 4] = c * m10 - s * m00
        dst[ 5] = c * m11 - s * m01
        dst[ 6] = c * m12 - s * m02
        dst[ 7] = c * m13 - s * m03

        if (m != dst) {
          dst[ 8] = m[ 8]
          dst[ 9] = m[ 9]
          dst[10] = m[10]
          dst[11] = m[11]
          dst[12] = m[12]
          dst[13] = m[13]
          dst[14] = m[14]
          dst[15] = m[15]
        }

        return dst
    }

    static scale(m, sx, sy, sz, dst) {
        if (!dst) dst = List.filled(16, 0)

        dst[ 0] = sx * m[0 * 4 + 0]
        dst[ 1] = sx * m[0 * 4 + 1]
        dst[ 2] = sx * m[0 * 4 + 2]
        dst[ 3] = sx * m[0 * 4 + 3]
        dst[ 4] = sy * m[1 * 4 + 0]
        dst[ 5] = sy * m[1 * 4 + 1]
        dst[ 6] = sy * m[1 * 4 + 2]
        dst[ 7] = sy * m[1 * 4 + 3]
        dst[ 8] = sz * m[2 * 4 + 0]
        dst[ 9] = sz * m[2 * 4 + 1]
        dst[10] = sz * m[2 * 4 + 2]
        dst[11] = sz * m[2 * 4 + 3]

        if (m != dst) {
            dst[12] = m[12]
            dst[13] = m[13]
            dst[14] = m[14]
            dst[15] = m[15]
        }

        return dst
    }
}

class C {
    foreign static usleep(usec)
}

// Fill the buffer with the values that define a letter 'F'.
var setGeometry = Fn.new {
    Gl.bufferData(
        GL_ARRAY_BUFFER,
        4, // size of 32 bit float
        [
            // left column front
             0,    0,   0,
             0,  150,   0,
            30,    0,   0,
             0,  150,   0,
            30,  150,   0,
            30,    0,   0,

            // top rung front
             30,   0,   0,
             30,  30,   0,
            100,   0,   0,
             30,  30,   0,
            100,  30,   0,
            100,   0,   0,

            // middle rung front
             30,  60,   0,
             30,  90,   0,
             67,  60,   0,
             30,  90,   0,
             67,  90,   0,
             67,  60,   0,

            // left column back
              0,   0,  30,
             30,   0,  30,
              0, 150,  30,
              0, 150,  30,
             30,   0,  30,
             30, 150,  30,

            // top rung back
             30,   0,  30,
            100,   0,  30,
             30,  30,  30,
             30,  30,  30,
            100,   0,  30,
            100,  30,  30,

            // middle rung back
             30,  60,  30,
             67,  60,  30,
             30,  90,  30,
             30,  90,  30,
             67,  60,  30,
             67,  90,  30,

            // top
              0,   0,   0,
            100,   0,   0,
            100,   0,  30,
              0,   0,   0,
            100,   0,  30,
              0,   0,  30,

            // top rung right
            100,   0,   0,
            100,  30,   0,
            100,  30,  30,
            100,   0,   0,
            100,  30,  30,
            100,   0,  30,

            // under top rung
             30,  30,   0,
             30,  30,  30,
            100,  30,  30,
             30,  30,   0,
            100,  30,  30,
            100,  30,   0,

            // between top rung and middle
             30,  30,   0,
             30,  60,  30,
             30,  30,  30,
             30,  30,   0,
             30,  60,   0,
             30,  60,  30,

            // top of middle rung
             30,  60,   0,
             67,  60,  30,
             30,  60,  30,
             30,  60,   0,
             67,  60,   0,
             67,  60,  30,

            // right of middle rung
             67,  60,   0,
             67,  90,  30,
             67,  60,  30,
             67,  60,   0,
             67,  90,   0,
             67,  90,  30,

            // bottom of middle rung.
             30,  90,   0,
             30,  90,  30,
             67,  90,  30,
             30,  90,   0,
             67,  90,  30,
             67,  90,   0,

            // right of bottom
             30,  90,   0,
             30, 150,  30,
             30,  90,  30,
             30,  90,   0,
             30, 150,   0,
             30, 150,  30,

            // bottom
              0, 150,   0,
              0, 150,  30,
             30, 150,  30,
              0, 150,   0,
             30, 150,  30,
             30, 150,   0,

            // left side
              0,   0,   0,
              0,   0,  30,
              0, 150,  30,
              0,   0,   0,
              0, 150,  30,
              0, 150,   0
        ],
        GL_STATIC_DRAW
    )
}

// Fill the buffer with colors for the 'F'.
var setColors = Fn.new {
    Gl.bufferData(
        GL_ARRAY_BUFFER,
        1, // size of unsigned byte
        [
            // left column front
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,

            // top rung front
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,

            // middle rung front
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,
            200,  70, 120,

            // left column back
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,

            // top rung back
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,

            // middle rung back
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,
             80,  70, 200,

            // top
             70, 200, 210,
             70, 200, 210,
             70, 200, 210,
             70, 200, 210,
             70, 200, 210,
             70, 200, 210,

            // top rung right
            200, 200,  70,
            200, 200,  70,
            200, 200,  70,
            200, 200,  70,
            200, 200,  70,
            200, 200,  70,

            // under top rung
            210, 100,  70,
            210, 100,  70,
            210, 100,  70,
            210, 100,  70,
            210, 100,  70,
            210, 100,  70,

            // between top rung and middle
            210, 160,  70,
            210, 160,  70,
            210, 160,  70,
            210, 160,  70,
            210, 160,  70,
            210, 160,  70,

            // top of middle rung
             70, 180, 210,
             70, 180, 210,
             70, 180, 210,
             70, 180, 210,
             70, 180, 210,
             70, 180, 210,

            // right of middle rung
            100,  70, 210,
            100,  70, 210,
            100,  70, 210,
            100,  70, 210,
            100,  70, 210,
            100,  70, 210,

            // bottom of middle rung.
             76, 210, 100,
             76, 210, 100,
             76, 210, 100,
             76, 210, 100,
             76, 210, 100,
             76, 210, 100,

            // right of bottom
            140, 210,  80,
            140, 210,  80,
            140, 210,  80,
            140, 210,  80,
            140, 210,  80,
            140, 210,  80,

            // bottom
             90, 130, 110,
             90, 130, 110,
             90, 130, 110,
             90, 130, 110,
             90, 130, 110,
             90, 130, 110,

            // left side
            160, 160, 220,
            160, 160, 220,
            160, 160, 220,
            160, 160, 220,
            160, 160, 220,
            160, 160, 220
        ],
        GL_STATIC_DRAW
    )
}

var Program
var PositionLocation
var ColorLocation
var MatrixLocation
var PositionBuffer
var ColorBuffer

var init = Fn.new {
    // create vertex shader
    var vShaderSource = """
    #version 100
    attribute vec4 a_position;
    attribute vec4 a_color;

    uniform mat4 u_matrix;

    varying vec4 v_color;

    void main() {
      // Multiply the position by the matrix.
      gl_Position = u_matrix * a_position;

      // Pass the color to the fragment shader.
      v_color = a_color;
    }
    """
    var vShader = Gl.createShader(GL_VERTEX_SHADER)
    if (vShader == 0) Fiber.abort("Error creating vertex shader.")
    Gl.shaderSource(vShader, 1, vShaderSource, null)
    Gl.compileShader(vShader)

    // create fragment shader
    var fShaderSource = """
    #version 100
    precision mediump float;

    // Passed in from the vertex shader.
    varying vec4 v_color;

    void main() {
       gl_FragColor = v_color;
    }
    """
    var fShader = Gl.createShader(GL_FRAGMENT_SHADER)
    if (fShader == 0) Fiber.abort("Error creating fragment shader.")
    Gl.shaderSource(fShader, 1, fShaderSource, null)
    Gl.compileShader(fShader)

    // setup GLSL program
    Program = Gl.createProgram()
    Gl.attachShader(Program, vShader)
    Gl.attachShader(Program, fShader)
    Gl.linkProgram(Program)

    // look up where the vertex data needs to go
    PositionLocation = Gl.getAttribLocation(Program, "a_position")
    ColorLocation = Gl.getAttribLocation(Program, "a_color")
    // lookup uniforms
    MatrixLocation = Gl.getUniformLocation(Program, "u_matrix")
    // generate 2 buffer object names
    var buffers = List.filled(2, 0)
    Gl.genBuffers(2, buffers)

    // Create a buffer to put positions in
    PositionBuffer = buffers[0]
    // Bind it to ARRAY_BUFFER
    Gl.bindBuffer(GL_ARRAY_BUFFER, PositionBuffer)
    // Put geometry data into buffer
    setGeometry.call()

    // Create a buffer to put colors in
    ColorBuffer = buffers[1]
    // Bind it to ARRAY_BUFFER
    Gl.bindBuffer(GL_ARRAY_BUFFER, ColorBuffer)
    // Put color data into buffer
    setColors.call()
}

var Translation = [0, 0, -360]
var Rotation = [Math.radians(190), Math.radians(40), Math.radians(320)]
var Scale = [1, 1, 1]
var FieldOfViewRadians = Math.radians(60)
var WindowWidth = 640
var WindowHeight = 480

var drawScene // recursive function
drawScene = Fn.new {
    Rotation[1] = Rotation[1] + 0.01
    if (Rotation[1] >= 360) Rotation[1] = 0

    // tell GLES how to convert from clip space to pixels
    Gl.viewport(0, 0, WindowWidth, WindowHeight)

    // clear the window and the depth buffer
    Gl.clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    // turn on culling. By default backfacing triangles will be culled
    Gl.enable(GL_CULL_FACE)

    // Enable the depth buffer
    Gl.enable(GL_DEPTH_TEST)

    // Tell it to use our program (pair of shaders)
    Gl.useProgram(Program)

    // Turn on the position attribute
    Gl.enableVertexAttribArray(PositionLocation)

    // Bind the position buffer.
    Gl.bindBuffer(GL_ARRAY_BUFFER, PositionBuffer)

    // tell the position attribute how to get data out of positionBuffer (ARRAY_BUFFER)
    var size = 3           // 3 components per iteration
    var type = GL_FLOAT    // the data is 32 bit floats
    var normalize = false  // don't normalize the data
    var stride = 0         // 0 = move forward size * sizeof(type) each iteration to get the next position
    var offset = 0         // start at the beginning of the buffer
    Gl.vertexAttribPtr(PositionLocation, size, type, normalize, stride, offset)

    // Turn on the color attribute
    Gl.enableVertexAttribArray(ColorLocation)

    // Bind the color buffer.
    Gl.bindBuffer(GL_ARRAY_BUFFER, ColorBuffer)

    // Tell the attribute how to get data out of colorBuffer (ARRAY_BUFFER)
    Gl.vertexAttribPtr(ColorLocation, size, type, normalize, stride, offset)

    // compute the matrices
    var aspect = WindowWidth / WindowHeight
    var matrix = M4.perspective(FieldOfViewRadians, aspect, 1, 2000, null)
    matrix = M4.translate(matrix, Translation[0], Translation[1], Translation[2], null)
    matrix = M4.xRotate(matrix, Rotation[0], null)
    matrix = M4.yRotate(matrix, Rotation[1], null)
    matrix = M4.zRotate(matrix, Rotation[2], null)
    matrix = M4.scale(matrix, Scale[0], Scale[1], Scale[2], null)

    // set the matrix
    Gl.uniformMatrix4fv(MatrixLocation, 1, false, matrix)

    // draw the geometry
    var primitiveType = GL_TRIANGLES
    var count = 16 * 6
    Gl.drawArrays(primitiveType, offset, count)
    Gl.flush()
    C.usleep(10000) // wait for 10 msec
    drawScene.call()
}

Glut.initDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH)
Glut.initWindowSize(640, 480)
Glut.createWindow("Rotating F")
Glut.setOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS)
init.call()
drawScene.call()
