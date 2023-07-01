require 'tk'

$root = TkRoot.new("title" => "Pendulum Animation")
$canvas = TkCanvas.new($root) do
  width 320
  height 200
  create TkcLine, 0,25,320,25,   'tags' => 'plate', 'width' => 2, 'fill' => 'grey50'
  create TkcOval, 155,20,165,30, 'tags' => 'pivot', 'outline' => "", 'fill' => 'grey50'
  create TkcLine, 1,1,1,1, 'tags' => 'rod', 'width' => 3, 'fill' => 'black'
  create TkcOval, 1,1,2,2, 'tags' => 'bob', 'outline' => 'black', 'fill' => 'yellow'
end
$canvas.raise('pivot')
$canvas.pack('fill' => 'both', 'expand' => true)

$Theta = 45.0
$dTheta = 0.0
$length = 150
$homeX = 160
$homeY = 25

def show_pendulum
  angle = $Theta * Math::PI / 180
  x = $homeX + $length * Math.sin(angle)
  y = $homeY + $length * Math.cos(angle)
  $canvas.coords('rod', $homeX, $homeY, x, y)
  $canvas.coords('bob', x-15, y-15, x+15, y+15)
end

def recompute_angle
  scaling = 3000.0 / ($length ** 2)
  # first estimate
  firstDDTheta = -Math.sin($Theta * Math::PI / 180) * scaling
  midDTheta = $dTheta + firstDDTheta
  midTheta = $Theta + ($dTheta + midDTheta)/2
  # second estimate
  midDDTheta = -Math.sin(midTheta * Math::PI / 180) * scaling
  midDTheta = $dTheta + (firstDDTheta + midDDTheta)/2
  midTheta = $Theta + ($dTheta + midDTheta)/2
  # again, first
  midDDTheta = -Math.sin(midTheta * Math::PI / 180) * scaling
  lastDTheta = midDTheta + midDDTheta
  lastTheta = midTheta + (midDTheta + lastDTheta)/2
  # again, second
  lastDDTheta = -Math.sin(lastTheta * Math::PI/180) * scaling
  lastDTheta = midDTheta + (midDDTheta + lastDDTheta)/2
  lastTheta = midTheta + (midDTheta + lastDTheta)/2
  # Now put the values back in our globals
  $dTheta  = lastDTheta
  $Theta = lastTheta
end

def animate
  recompute_angle
  show_pendulum
  $after_id = $root.after(15) {animate}
end

show_pendulum
$after_id = $root.after(500) {animate}

$canvas.bind('<Destroy>') {$root.after_cancel($after_id)}

Tk.mainloop
