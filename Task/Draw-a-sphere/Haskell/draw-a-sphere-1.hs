import Graphics.Rendering.OpenGL.GL
import Graphics.UI.GLUT.Objects
import Graphics.UI.GLUT

setProjection :: IO ()
setProjection = do
  matrixMode $= Projection
  ortho (-1) 1 (-1) 1 0 (-1)

grey1,grey9,red,white :: Color4 GLfloat
grey1 = Color4 0.1 0.1 0.1 1
grey9 = Color4 0.9 0.9 0.9 1
red   = Color4 1   0   0   1
white = Color4 1   1   1   1

setLights :: IO ()
setLights = do
  let l = Light 0
  ambient  l $= grey1
  diffuse  l $= white
  specular l $= white
  position l $= Vertex4 (-4) 4 3 (0 :: GLfloat)
  light    l $= Enabled
  lighting   $= Enabled

setMaterial :: IO ()
setMaterial = do
  materialAmbient   Front $= grey1
  materialDiffuse   Front $= red
  materialSpecular  Front $= grey9
  materialShininess Front $= (32 :: GLfloat)

display :: IO()
display = do
  clear [ColorBuffer]
  renderObject Solid $ Sphere' 0.8 64 64
  swapBuffers

main :: IO()
main = do
  _ <- getArgsAndInitialize
  _ <- createWindow "Sphere"
  clearColor $= Color4 0.0 0.0 0.0 0.0
  setProjection
  setLights
  setMaterial
  displayCallback $= display
  mainLoop
