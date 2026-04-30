include get.e
include dll.e
include machine.e
include msgbox.e
include constants.ew
include GLfunc.ew
include GLconst.ew

without warning

atom hRC, hDC, hWnd, hInstance, ClassName
sequence keys keys = repeat(0,256)  -- array to hold key presses

integer active, fullscreen, retval
active = TRUE
fullscreen = TRUE
hRC = NULL
hDC = NULL
hWnd = NULL
hInstance = NULL

atom rtri, rquad
rtri = 0.0
rquad = 0.0

integer dmScreenSettings, WindowRect

procedure ReSizeGLScene(integer width, integer height)
    if height = 0 then
        height = 1
    end if
    c_proc(glViewport,{0,0,width,height})
    c_proc(glMatrixMode,{GL_PROJECTION})
    c_proc(glLoadIdentity,{})
    c_proc(gluPerspective,{45.0,width/height,0.1,100.0})
    c_proc(glMatrixMode,{GL_MODELVIEW})
    c_proc(glLoadIdentity,{})
end procedure

procedure InitGL()
    c_proc(glShadeModel,{GL_SMOOTH})
    c_proc(glClearColor,{0.0,0.0,0.0,0.0})
    c_proc(glClearDepth,{1.0})
    c_proc(glEnable,{GL_DEPTH_TEST})
    c_proc(glDepthFunc,{GL_LEQUAL})
    c_proc(glHint,{GL_PERSPECTIVE_CORRECTION_HINT,GL_NICEST})
end procedure

function DrawGLScene()
    c_proc(glClear, {or_bits(GL_COLOR_BUFFER_BIT,GL_DEPTH_BUFFER_BIT)})
    c_proc(glLoadIdentity, {})
    c_proc(glTranslatef, {-1.5,0.0,-6.0})
    c_proc(glRotatef, {rtri,0.0,1.0,0.0})
    c_proc(glBegin, {GL_TRIANGLES})
    c_proc(glColor3f, {1.0,0.0,0.0})
    c_proc(glVertex3f, {0.0,1.0,0.0})
    c_proc(glColor3f, {0.0,1.0,0.0})
    c_proc(glVertex3f, {-1.0,-1.0,0.0})
    c_proc(glColor3f, {0.0,0.0,1.0})
    c_proc(glVertex3f, {1.0,-1.0,0.0})
    c_proc(glEnd, {})
    c_proc(glLoadIdentity, {})
    c_proc(glTranslatef, {1.5,0.0,-6.0})
    c_proc(glRotatef, {rquad,1.0,0.0,0.0})
    c_proc(glColor3f, {0.5,0.5,1.0})
    c_proc(glBegin, {GL_QUADS})
    c_proc(glVertex3f, {1.0,1.0,0.0})
    c_proc(glVertex3f, {-1.0,1.0,0.0})
    c_proc(glVertex3f, {-1.0,-1.0,0.0})
    c_proc(glVertex3f, {1.0,-1.0,0.0})
    c_proc(glEnd, {})
    rtri += 0.2
    rquad -= 0.15
    return TRUE
end function

procedure KillGLWindow()
    if fullscreen then
        if c_func(ChangeDisplaySettingsA,{NULL,0}) then end if
        if c_func(ShowCursor,{TRUE}) then end if
    end if
    if hRC then
        if c_func(wglMakeCurrent,{NULL,NULL}) then end if
        if c_func(wglDeleteContext,{hRC}) then end if
        hRC = NULL
    end if
    if hRC and not c_func(ReleaseDC,{hWnd,hDC}) then
        hDC = NULL
    end if
    if hWnd and not c_func(DestroyWindow,{hWnd}) then
        hWnd = NULL
    end if
    if dmScreenSettings then
        free(dmScreenSettings)
    end if
    free(WindowRect)
end procedure

function WndProc(atom hWnd, integer uMsg, atom wParam, atom lParam)
    if uMsg = WM_ACTIVATE then
        if not floor(wParam/#10000) then
            active = TRUE
        else
            active = FALSE
        end if
    elsif  uMsg = WM_SYSCOMMAND then
        if wParam = SC_SCREENSAVE then end if
        if wParam = SC_MONITORPOWER then end if
    elsif uMsg = WM_CLOSE then
        c_proc(PostQuitMessage,{0})
    elsif uMsg = WM_KEYDOWN then
        keys[wParam] = TRUE
    elsif uMsg = WM_KEYUP then
        keys[wParam] = FALSE
    elsif uMsg = WM_SIZE then
        ReSizeGLScene(and_bits(lParam,#FFFF),floor(lParam/#10000))
    end if
    return c_func(DefWindowProcA,{hWnd, uMsg, wParam, lParam})
end function

integer wc wc = allocate(40)
function ClassRegistration()
integer WndProcAddress, id
    id = routine_id("WndProc")
    if id = -1 then
    puts(1, "routine_id failed!\n")
    abort(1)
    end if
    WndProcAddress = call_back(id)
    hInstance = c_func(GetModuleHandleA,{NULL})
    ClassName = allocate_string("OpenGL")
    poke4(wc,or_all({CS_HREDRAW, CS_VREDRAW, CS_OWNDC}))
    poke4(wc+4,WndProcAddress)
    poke4(wc+8,0)
    poke4(wc+12,0)
    poke4(wc+16,hInstance)
    poke4(wc+20,c_func(LoadIconA,{NULL,IDI_WINLOGO}))
    poke4(wc+24,c_func(LoadCursorA,{NULL, IDC_ARROW}))
    poke4(wc+28,NULL)
    poke4(wc+32,NULL)
    poke4(wc+36,ClassName)
    if not c_func(RegisterClassA,{wc}) then
        retval = message_box("Failed to register class","Error", or_bits(MB_OK,MB_ICONINFORMATION))
        return FALSE
    else
        return TRUE
    end if
end function

integer regd regd = FALSE
procedure CreateGLWindow(atom title, integer width, integer height, integer bits, integer fullscreenflag)
    atom PixelFormat, pfd, dwExStyle, dwStyle
    sequence s
    if regd = FALSE then
        if ClassRegistration() then
            regd = TRUE
        end if
    end if
    fullscreen = fullscreenflag
    if fullscreen then
        dmScreenSettings = allocate(156)
        mem_set(dmScreenSettings,0,156)
        s = int_to_bytes(156)
        poke(dmScreenSettings + 36,{s[1],s[2]})
        poke4(dmScreenSettings + 40,or_all({DM_BITSPERPEL,DM_PELSWIDTH,DM_PELSHEIGHT}))
        poke4(dmScreenSettings + 104, bits)
        poke4(dmScreenSettings + 108, width)
        poke4(dmScreenSettings + 112, height)
        if c_func(ChangeDisplaySettingsA,{dmScreenSettings,CDS_FULLSCREEN}) != DISP_CHANGE_SUCCESSFUL then
            if message_box("The requested fullscreen mode is not supported by\nyour video card. " &
                           "Use windowed mode instead?","Error", or_bits(MB_YESNO,MB_ICONEXCLAMATION)) = IDYES then
            else
                retval = message_box("Program will now close","Error",or_bits(MB_OK,MB_ICONSTOP))
            end if
        end if
    else
        dmScreenSettings = NULL
    end if
    if fullscreen then
        dwExStyle = WS_EX_APPWINDOW
        dwStyle = WS_POPUP
        if c_func(ShowCursor,{FALSE}) then end if
    else
        dwExStyle = or_bits(WS_EX_APPWINDOW,WS_EX_WINDOWEDGE)
        dwStyle = WS_OVERLAPPEDWINDOW
    end if
    WindowRect = allocate(16)
    poke4(WindowRect,0)
    poke4(WindowRect + 4,width)
    poke4(WindowRect + 8, 0)
    poke4(WindowRect + 12, height)
    if c_func(AdjustWindowRectEx,{WindowRect, dwStyle, FALSE, dwExStyle}) then end if
    hWnd = c_func(CreateWindowExA,{dwExStyle,  --extended window style
                                   ClassName,  --class
                                   title,      --window caption
                                   or_all({WS_CLIPSIBLINGS,WS_CLIPCHILDREN,dwStyle}),  --window style
                                   0,
                                   0,
                                   peek4u(WindowRect + 4) - peek4u(WindowRect),
                                   peek4u(WindowRect + 12) - peek4u(WindowRect + 8),
                                   NULL,
                                   NULL,
                                   hInstance,
                                   NULL})
    if hWnd = NULL then
        KillGLWindow()
        retval = message_box("Window creation error","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    pfd = allocate(40)  --PIXELFORMATDESCRIPTOR
    mem_set(pfd,0,40)
    poke(pfd, 40)  --size of pfd structure
    poke(pfd + 2, 1) --version
    poke4(pfd + 4, or_all({PFD_DRAW_TO_WINDOW,PFD_SUPPORT_OPENGL,PFD_DOUBLEBUFFER})) --properties flags
    poke(pfd + 8, PFD_TYPE_RGBA)  --request an rgba format
    poke(pfd + 9, 24)  --select color depth
    poke(pfd + 23, 24)  --32bit Z-buffer

    hDC = c_func(GetDC,{hWnd})  --create GL device context to match window device context
    if not hDC then
        KillGLWindow()
        retval = message_box("Can't create a GL device context","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    PixelFormat = c_func(ChoosePixelFormat,{hDC,pfd})  --find a pixel format matching PIXELFORMATDESCRIPTOR
    if not PixelFormat then
        KillGLWindow()
        retval = message_box("Can't find a suitable pixel format","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    if not (c_func(SetPixelFormat,{hDC,PixelFormat,pfd})) then  --set the pixel format
        KillGLWindow()
        retval = message_box("Can't set the pixel format","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    if not c_func(DescribePixelFormat, {hDC,PixelFormat,40,pfd}) then
        retval = message_box("Can't describe the pixel format","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    hRC = c_func(wglCreateContext,{hDC})  --create GL rendering context
    if not hRC then
        KillGLWindow()
        retval = message_box("Can't create a GL rendering context","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    if not (c_func(wglMakeCurrent,{hDC,hRC})) then  --make the GL rendering context active
        KillGLWindow()
        retval = message_box("Can't activate the GL rendering context","Error",or_bits(MB_OK,MB_ICONEXCLAMATION))
    end if
    retval = c_func(ShowWindow,{hWnd,SW_SHOW}) --show the window
    retval = c_func(SetForegroundWindow,{hWnd}) --set it to always be in foreground
    retval = c_func(SetFocus,{hWnd}) --give it focus
    ReSizeGLScene(width, height)  --draw the GL scene to match the window size
    InitGL()  --initialize OpenGL
end procedure

integer MSG MSG = allocate(28)
integer title title = allocate_string("OpenGL")
procedure WinMain()
integer done, msg_message
    done = FALSE
    if message_box("Would you like to run in fullscreen mode?","Start Fullscreen?",or_bits(MB_YESNO,MB_ICONQUESTION)) = IDNO then
        fullscreen = FALSE
    else
        fullscreen = TRUE
    end if
    CreateGLWindow(title,640,480,24,fullscreen)
    while not done do
        if c_func(PeekMessageA,{MSG,NULL,0,0,PM_REMOVE}) then
            msg_message = peek4u(MSG+4)
            if msg_message = WM_QUIT then
                done = TRUE
            else
                retval = c_func(TranslateMessage,{MSG})
                retval = c_func(DispatchMessageA,{MSG})
            end if
        else
            if ((active and not DrawGLScene()) or keys[VK_ESCAPE]) then
                done = TRUE
            else
                retval = c_func(SwapBuffers,{hDC})
                if keys[VK_F1] then
                    keys[VK_F1] = FALSE
                    KillGLWindow()
                    if fullscreen = 0 then
                        fullscreen = 1
                    else
                        fullscreen = 0
                    end if
                    CreateGLWindow(title,640,480,24,fullscreen)
                end if
            end if
        end if
    end while
    KillGLWindow()
end procedure

WinMain()
