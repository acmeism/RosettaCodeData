Red [
    Title: "Pendulum Animation"
	Author: "hinjolicious"
	Resources: "Claude"
	Needs: 'View
]

; --- Physics constants ---
g: 9.81        ; gravity (m/s²)
L: 1.0         ; rod length (meters)
scale: 150     ; pixels per meter

; --- Pendulum state ---
theta:  1.5708 ; initial angle (radians, ~90°)
omega:  0.0    ; angular velocity

last-time: none
dt:     0.016  ; time step (~60fps)

; --- Canvas center (pivot point) ---
cx: 200
cy: 25

canvas: none

update-pendulum: func [] [
	if dt > 0.05 [dt: 0.05]
	
    ; Exact equation of motion: α = -(g/L) * sin(θ)
    alpha: (0.0 - (g / L)) * sine/radians theta
    omega: omega + (alpha * dt)
    theta: theta + (omega * dt)

    ; Bob position
    bx: cx + to-integer (sine/radians theta  ) * L * scale
    by: cy + to-integer (cosine/radians theta) * L * scale

    ; Redraw
    canvas/draw: compose [
        ; Pivot dot
        fill-pen blue  pen off
        circle (as-pair cx cy) 5

        ; Rod
        pen gray  line-width 1
        line (as-pair cx cy) (as-pair bx by)

        ; Bob (red)
        fill-pen red  pen red  line-width 1
		circle (as-pair bx by) 10
    ]
]

view [
    title "Pendulum"
    canvas: base 400x200 black rate 60
	on-time [
		current: now/time/precise
		either none? last-time [
			last-time: current
		][
			dt: to-float current - last-time
			last-time: current
			update-pendulum
		]	
	]
    ;do [update-pendulum]
]
