package main

import (
	"github.com/google/gxui"
	"github.com/google/gxui/drivers/gl"
	"github.com/google/gxui/math"
	"github.com/google/gxui/themes/dark"
	omath "math"
	"time"
)

//Two pendulums animated
//Top: Mathematical pendulum with small-angle approxmiation (not appropiate with PHI_ZERO=pi/2)
//Bottom: Simulated with differential equation phi'' = g/l * sin(phi)

const (
	ANIMATION_WIDTH  int     = 480
	ANIMATION_HEIGHT int     = 320
	BALL_RADIUS      float32 = 25.0
	METER_PER_PIXEL  float64 = 1.0 / 20.0
	PHI_ZERO         float64 = omath.Pi * 0.5
)

var (
	l    float64 = float64(ANIMATION_HEIGHT) * 0.5
	freq float64 = omath.Sqrt(9.81 / (l * METER_PER_PIXEL))
)

type Pendulum interface {
	GetPhi() float64
}

type mathematicalPendulum struct {
	start time.Time
}

func (p *mathematicalPendulum) GetPhi() float64 {
	if (p.start == time.Time{}) {
		p.start = time.Now()
	}
	t := float64(time.Since(p.start).Nanoseconds()) / omath.Pow10(9)
	return PHI_ZERO * omath.Cos(t*freq)
}

type numericalPendulum struct {
	currentPhi float64
	angAcc     float64
	angVel     float64
	lastTime   time.Time
}

func (p *numericalPendulum) GetPhi() float64 {
	dt := 0.0
	if (p.lastTime != time.Time{}) {
		dt = float64(time.Since(p.lastTime).Nanoseconds()) / omath.Pow10(9)
	}
	p.lastTime = time.Now()

	p.angAcc = -9.81 / (float64(l) * METER_PER_PIXEL) * omath.Sin(p.currentPhi)
	p.angVel += p.angAcc * dt
	p.currentPhi += p.angVel * dt

	return p.currentPhi
}

func draw(p Pendulum, canvas gxui.Canvas, x, y int) {
	attachment := math.Point{X: ANIMATION_WIDTH/2 + x, Y: y}

	phi := p.GetPhi()
	ball := math.Point{X: x + ANIMATION_WIDTH/2 + math.Round(float32(l*omath.Sin(phi))), Y: y + math.Round(float32(l*omath.Cos(phi)))}

	line := gxui.Polygon{gxui.PolygonVertex{attachment, 0}, gxui.PolygonVertex{ball, 0}}

	canvas.DrawLines(line, gxui.DefaultPen)

	m := math.Point{int(BALL_RADIUS), int(BALL_RADIUS)}
	rect := math.Rect{ball.Sub(m), ball.Add(m)}
	canvas.DrawRoundedRect(rect, BALL_RADIUS, BALL_RADIUS, BALL_RADIUS, BALL_RADIUS, gxui.TransparentPen, gxui.CreateBrush(gxui.Yellow))
}

func appMain(driver gxui.Driver) {
	theme := dark.CreateTheme(driver)

	window := theme.CreateWindow(ANIMATION_WIDTH, 2*ANIMATION_HEIGHT, "Pendulum")
	window.SetBackgroundBrush(gxui.CreateBrush(gxui.Gray50))

	image := theme.CreateImage()

	ticker := time.NewTicker(time.Millisecond * 15)
	pendulum := &mathematicalPendulum{}
	pendulum2 := &numericalPendulum{PHI_ZERO, 0.0, 0.0, time.Time{}}

	go func() {
		for _ = range ticker.C {
			canvas := driver.CreateCanvas(math.Size{ANIMATION_WIDTH, 2 * ANIMATION_HEIGHT})
			canvas.Clear(gxui.White)

			draw(pendulum, canvas, 0, 0)
			draw(pendulum2, canvas, 0, ANIMATION_HEIGHT)

			canvas.Complete()
			driver.Call(func() {
				image.SetCanvas(canvas)
			})
		}
	}()

	window.AddChild(image)

	window.OnClose(ticker.Stop)
	window.OnClose(driver.Terminate)
}

func main() {
	gl.StartDriver(appMain)
}
