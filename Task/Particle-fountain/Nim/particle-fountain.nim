import std/[lenientops, math, monotimes, random, times]
import sdl2

type ParticleFountain[N: static Positive] = object
  positions: array[1..2 * N, float]
  velocities: array[1..2 * N, float]
  lifetimes: array[1..N, float]
  points: array[1..N, Point]
  numPoints: int
  saturation: float
  spread: float
  range: float
  reciprocate: bool

proc initParticleFountain[N: static Positive](): ParticleFountain[N] =
  ParticleFountain[N](saturation: 0.4, spread: 1.5, range: 1.5)

proc update(pf: var ParticleFountain; w, h: cint; df: float) =
  var
    xidx = 1
    yidx = 2
    pointidx = 0

  template recip(pf: ParticleFountain): float =
    if pf.reciprocate: pf.range * sin(epochTime() / 1000) else: 0.0

  for idx in 1..pf.N:
    var willDraw = false
    if pf.lifetimes[idx] <= 0:
      if rand(1.0) < df:
        pf.lifetimes[idx] = 2.5   # Time to live.
        # Starting position.
        pf.positions[xidx] = w / 20
        pf.positions[yidx] = h / 10
        # Starting velocity.
        pf.velocities[xidx] = 10 * (pf.spread * rand(1.0) - pf.spread / 2 + pf.recip())
        pf.velocities[yidx] = (rand(1.0) - 2.9) * h / 20.5
        willDraw = true
    else:
      if pf.positions[yidx] > h / 10 and pf.velocities[yidx] > 0:
        pf.velocities[yidx] *= -0.3   # "Bounce".
      pf.velocities[yidx] += df * h / 10                  # Adjust velocity.
      pf.positions[xidx] += pf.velocities[xidx] * df      # Adjust position x.
      pf.positions[yidx] += pf.velocities[yidx] * df      # Adjust position y.
      pf.lifetimes[idx] -= df
      willDraw = true

    if willDraw:
      # Gather all of the points that are going to be rendered.
      inc pointIdx
      pf.points[pointidx] = (cint(pf.positions[xidx] * 10), cint(pf.positions[yidx] * 10))
    inc xidx, 2
    yidx = xidx + 1
    pf.numPoints = pointidx

func hsvToRgb(h, s, v: float): (byte, byte, byte) =
  let hp = h / 60.0
  let c = s * v
  let x = c * (1 - abs(hp mod 2 - 1))
  let m = v - c
  var (r, g, b) = if hp <= 1: (c, x, 0.0)
                  elif hp <= 2: (x, c, 0.0)
                  elif hp <= 3: (0.0, c, x)
                  elif hp <= 4: (0.0, x, c)
                  elif hp <= 5: (x, 0.0, c)
                  else: (c, 0.0, x)
  r += m
  g += m
  b += m
  result = (byte(r * 255), byte(g * 255), byte(b * 255))

proc fountain(particleNum = 3000; w = 800; h = 800) =
  var w = w.cint
  var h = h.cint
  discard sdl2.init(INIT_VIDEO or INIT_EVENTS)
  let window = createWindow("Nim Particle System!", SDL_WINDOWPOS_CENTERED_MASK,
                            SDL_WINDOWPOS_CENTERED_MASK, w, h, SDL_WINDOW_RESIZABLE)
  let renderer = createRenderer(window, -1, 0)
  clearError()
  var df = 0.0001
  var pf = initParticleFountain[3000]()
  var close = false
  var frames = 0
  block Simulation:
    while not close:
      let dfStart = getMonoTime()
      var event: Event
      while bool(pollEvent(event)):
        case event.kind
        of QuitEvent:
          break Simulation
        of WindowEvent:
          if event.window.event == WindowEvent_Resized:
            w = event.window.data1
            h = event.window.data2
        of KeyDown:
          let comm = event.key.keysym.sym
          case comm
          of K_UP:
            pf.saturation = min(pf.saturation + 0.1, 1.0)
          of K_DOWN:
            pf.saturation = max(pf.saturation - 0.1, 0.0)
          of K_PAGEUP:
            pf.spread = min(pf.spread + 1.0, 50.0)
          of K_PAGEDOWN:
            pf.spread = max(pf.spread - 0.1, 0.2)
          of K_LEFT:
            pf.range = min(pf.range + 0.1, 12.0)
          of K_RIGHT:
            pf.range = max(pf.range - 0.1, 0.1)
          of K_SPACE:
            pf.reciprocate = not pf.reciprocate
          of K_Q:
            break Simulation
          else:
            discard
        else:
          discard

      pf.update(w, h, df)
      renderer.setDrawColor(0x0, 0x0, 0x0, 0xff)
      renderer.clear()
      let (red, green, blue) = hsvToRgb(epochTime() mod 5 * 72, pf.saturation, 1.0)
      renderer.setDrawColor(red, green, blue, 0x7f)
      renderer.drawPoints(pf.points[1].addr, pf.numPoints.cint)
      renderer.present()
      inc frames
      df = (getMonoTime() - dfStart).inMilliseconds.float / 1000

  sdl2.quit()

randomize()
echo """
  Use UP and DOWN arrow keys to modify the saturation of the particle colors.
  Use PAGE UP and PAGE DOWN keys to modify the "spread" of the particles.
  Toggle reciprocation off / on with the SPACE bar.
  Use LEFT and RIGHT arrow keys to modify angle range for reciprocation.
  Press the "q" key to quit.
"""
fountain()
