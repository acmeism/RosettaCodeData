# Project : Animate a pendulum

load "guilib.ring"
load "stdlib.ring"

CounterMan = 1
paint = null
pi = 22/7
theta = pi/180*40
g = 9.81
l = 0.50
speed = 0

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Animate a pendulum")
                  setgeometry(100,100,800,600)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,800,600)
                              settext("")
                  }
                  new qpushbutton(win1) {
                          setgeometry(150,500,100,30)
                          settext("draw")
                          setclickevent("draw()")
                  }
                  TimerMan = new qtimer(win1)
                  {
                                    setinterval(1000)
                                    settimeoutevent("draw()")
                                    start()
                  }
                  show()
        }
        exec()
        }

func draw
        p1 = new qpicture()
               color = new qcolor() {
               setrgb(0,0,255,255)
        }
        pen = new qpen() {
                 setcolor(color)
                 setwidth(1)
        }
        paint = new qpainter() {
                  begin(p1)
                  setpen(pen)
        ptime()
        endpaint()
        }
        label1 { setpicture(p1) show() }
        return

 func ptime()
         TimerMan.start()
         pPlaySleep()
         sleep(0.1)
         CounterMan++
         if CounterMan = 20
            TimerMan.stop()
         ok

func pPlaySleep()
       pendulum(theta, l)
       pendulum(theta, l)
       accel = - g * sin(theta) / l / 100
       speed = speed + accel / 100
       theta = theta + speed

func pendulum(a, l)
       pivotx = 640
       pivoty = 800
       bobx = pivotx + l * 1000 * sin(a)
       boby = pivoty - l * 1000 * cos(a)
       paint.drawline(pivotx, pivoty, bobx, boby)
       paint.drawellipse(bobx + 24 * sin(a), boby - 24 * cos(a), 24, 24)
