when defined(windows):
  import winlean
else:
  {.error: "not supported os".}

type
  InputType = enum
    itMouse itKeyboard itHardware
  KeyEvent = enum
    keExtendedKey = 0x0001
    keKeyUp = 0x0002
    keUnicode = 0x0004
    keScanCode = 0x0008


  MouseInput {.importc: "MOUSEINPUT".} = object
    dx, dy: clong
    mouseData, dwFlags, time: culong
    dwExtraInfo: int # ULONG_PTR

  KeybdInput {.importc: "KEYBDINPUT".} = object
    wVk, wScan: cint
    dwFlags, time: culong
    dwExtraInfo: int

  HardwareInput {.importc: "HARDWAREINPUT".} = object
    uMsg: clong
    wParamL, wParamH: cint

  InputUnion {.union.} = object
    hi: HardwareInput
    mi: MouseInput
    ki: KeybdInput
  Input = object
    `type`: clong
    hwin: InputUnion

proc sendInput(total: cint, inp: ptr Input, size: cint) {.importc: "SendInput", header: "<windows.h>".}

proc initKey(keycode: int): Input =
  result = Input(`type`: itKeyboard.clong)
  var keybd = KeybdInput(wVk: keycode.cint, wScan: 0, time: 0,
    dwExtraInfo: 0, dwFlags: 0)
  result.hwin = InputUnion(ki: keybd)

proc pressKey(input: var Input) =
  input.hwin.ki.dwFlags = keExtendedKey.culong
  sendInput(cint 1, addr input, sizeof(Input).cint)

proc releaseKey(input: var Input) =
  input.hwin.ki.dwFlags = keExtendedKey.culong or keKeyUp.culong
  sendInput(cint 1, addr input, sizeof(Input).cint)

proc pressRelease(input: var Input) =
  input.pressKey
  input.releaseKey

proc pressReleaseKeycode(input: var Input, code: int) =
  input.hwin.ki.wVk = code.cint
  input.pressRelease

proc main =
  var
    shift = initKey 0xa0 # VK_LSHIFT
    key = initKey 0x48

  pressKey shift
  pressRelease key
  releaseKey shift
  key.pressReleaseKeycode 0x45 # e key
  key.pressReleaseKeycode 0x4c # l key
  key.pressReleaseKeycode 0x4c # l key
  key.pressReleaseKeycode 0x4f # o key
  key.pressReleaseKeycode 0x20 # VK_SPACE
  key.pressReleaseKeycode 0x57 # w key
  key.pressReleaseKeycode 0x4f # o key
  key.pressReleaseKeycode 0x52 # r key
  key.pressReleaseKeycode 0x4c # l key
  key.pressReleaseKeycode 0x44 # d key

main()
