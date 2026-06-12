object Form1: TForm1
  ClientHeight = 360
  ClientWidth = 640
  DoubleBuffered = True
  OnCreate = FormCreate
  OnPaint = FormPaint
  object tmr1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmr1Timer
  end
end
