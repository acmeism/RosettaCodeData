# Wrap win32 API function mouse_event() from the User32 dll.
function mouse_event_wrapper(dwFlags,dx,dy,dwData,dwExtraInfo)
    ccall((:mouse_event, "User32"),stdcall,Nothing,(UInt32,UInt32,UInt32,UInt32,UInt),dwFlags,dx,dy,dwData,dwExtraInfo)
end

function click()
    mouse_event_wrapper(0x2,0,0,0,0)
    mouse_event_wrapper(0x4,0,0,0,0)
end
