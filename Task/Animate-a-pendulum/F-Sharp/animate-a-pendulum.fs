open System
open System.Drawing
open System.Windows.Forms

// define units of measurement
[<Measure>] type m;  // metres
[<Measure>] type s;  // seconds

// a pendulum is represented as a record of physical quantities
type Pendulum =
 { length   : float<m>
   gravity  : float<m/s^2>
   velocity : float<m/s>
   angle    : float
 }

// calculate the next state of a pendulum
let next pendulum deltaT : Pendulum =
  let k = -pendulum.gravity / pendulum.length
  let acceleration = k * Math.Sin pendulum.angle * 1.0<m>
  let newVelocity = pendulum.velocity + acceleration * deltaT
  let newAngle = pendulum.angle + newVelocity * deltaT / 1.0<m>
  { pendulum with velocity = newVelocity; angle = newAngle }

// paint a pendulum (using hard-coded screen coordinates)
let paint pendulum (gr: System.Drawing.Graphics) =
  let homeX = 160
  let homeY = 50
  let length = 140.0
  // draw plate
  gr.DrawLine( new Pen(Brushes.Gray, width=2.0f), 0, homeY, 320, homeY )
  // draw pivot
  gr.FillEllipse( Brushes.Gray,           homeX-5, homeY-5, 10, 10 )
  gr.DrawEllipse( new Pen(Brushes.Black), homeX-5, homeY-5, 10, 10 )
  // draw the pendulum itself
  let x = homeX + int( length * Math.Sin pendulum.angle )
  let y = homeY + int( length * Math.Cos pendulum.angle )
  // draw rod
  gr.DrawLine( new Pen(Brushes.Black, width=3.0f), homeX, homeY, x, y )
  // draw bob
  gr.FillEllipse( Brushes.Yellow,         x-15, y-15, 30, 30 )
  gr.DrawEllipse( new Pen(Brushes.Black), x-15, y-15, 30, 30 )

// defines an operator "-?" that calculates the time from t2 to t1
// where t2 is optional
let (-?) (t1: DateTime) (t2: DateTime option) : float<s> =
  match t2 with
  | None   -> 0.0<s> // only one timepoint given -> difference is 0
  | Some t -> (t1 - t).TotalSeconds * 1.0<s>

// our main window is double-buffered form that reacts to paint events
type PendulumForm() as self =
  inherit Form(Width=325, Height=240, Text="Pendulum")
  let mutable pendulum = { length   = 1.0<m>;
                           gravity  = 9.81<m/s^2>
                           velocity = 0.0<m/s>
                           angle    = Math.PI / 2.0
                         }
  let mutable lastPaintedAt = None
  let updateFreq = 0.01<s>

  do self.DoubleBuffered <- true
     self.Paint.Add( fun args ->
       let now = DateTime.Now
       let deltaT = now -? lastPaintedAt |> min 0.01<s>
       lastPaintedAt <- Some now

       pendulum <- next pendulum deltaT

       let gr = args.Graphics
       gr.Clear( Color.LightGray )
       paint pendulum gr

       // initiate a new paint event after a while (non-blocking)
       async { do! Async.Sleep( int( 1000.0 * updateFreq / 1.0<s> ) )
               self.Invalidate()
            }
       |> Async.Start
     )

[<STAThread>]
Application.Run( new PendulumForm( Visible=true ) )
