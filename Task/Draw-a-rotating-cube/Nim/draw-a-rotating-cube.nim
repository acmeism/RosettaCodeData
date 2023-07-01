import math
import sdl2

const
  Width = 500
  Height = 500
  Offset = 500 / 2

var nodes = [(x: -100.0, y: -100.0, z: -100.0),
             (x: -100.0, y: -100.0, z:  100.0),
             (x: -100.0, y:  100.0, z: -100.0),
             (x: -100.0, y:  100.0, z:  100.0),
             (x:  100.0, y: -100.0, z: -100.0),
             (x:  100.0, y: -100.0, z:  100.0),
             (x:  100.0, y:  100.0, z:  -100.0),
             (x:  100.0, y:  100.0, z:   100.0)]

const Edges = [(a: 0, b: 1), (a: 1, b: 3), (a: 3, b: 2), (a: 2, b: 0),
               (a: 4, b: 5), (a: 5, b: 7), (a: 7, b: 6), (a: 6, b: 4),
               (a: 0, b: 4), (a: 1, b: 5), (a: 2, b: 6), (a: 3, b: 7)]

var
  window: WindowPtr
  renderer: RendererPtr
  event: Event
  endSimulation = false

#---------------------------------------------------------------------------------------------------

proc rotateCube(angleX, angleY: float) =
  let
    sinX = sin(angleX)
    cosX = cos(angleX)
    sinY = sin(angleY)
    cosY = cos(angleY)

  for node in nodes.mitems:
    var (x, y, z) = node
    node.x = x * cosX - z * sinX
    node.z = z * cosX + x * sinX
    z = node.z
    node.y = y * cosY - z * sinY
    node.z = z * cosY + y * sinY

#---------------------------------------------------------------------------------------------------

proc pollQuit(): bool =
  while pollEvent(event):
    if event.kind == QuitEvent:
      return true

#---------------------------------------------------------------------------------------------------

proc drawCube(): bool =
  var rect: Rect = (cint(0), cint(0), cint(Width), cint(Height))
  rotateCube(PI / 4, arctan(sqrt(2.0)))
  for frame in 0..359:
    renderer.setDrawColor((0u8, 0u8, 0u8, 255u8))
    renderer.fillRect(addr(rect))
    renderer.setDrawColor((0u8, 220u8, 0u8, 255u8))
    for edge in Edges:
      let xy1 = nodes[edge.a]
      let xy2 = nodes[edge.b]
      renderer.drawLine(cint(xy1.x + Offset), cint(xy1.y + Offset),
                        cint(xy2.x + Offset), cint(xy2.y + Offset))
    rotateCube(PI / 180, 0)
    renderer.present()
    if pollQuit(): return true
    delay 10

#———————————————————————————————————————————————————————————————————————————————————————————————————

if sdl2.init(INIT_EVERYTHING) == SdlError:
  quit(QuitFailure)

window = createWindow("Rotating cube", 10, 10, 500, 500, 0)
renderer = createRenderer(window, -1, Renderer_Accelerated)

while not endSimulation:
  endSimulation = drawCube()
window.destroy()
