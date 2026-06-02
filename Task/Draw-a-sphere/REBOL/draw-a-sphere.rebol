Rebol [
    title: "Rosetta code: Draw a sphere"
    file:  %Draw_a_sphere.r3
    url:   https://rosettacode.org/wiki/Draw_a_sphere
]

draw-sphere: function/with [size [pair!]][
    width: size/x  height: size/y  p: 1
    img: make image! size
    ray: make ray! [origin: camera]
    repeat row height [
        y: height - row + 1
        repeat col width [
            u: col / width
            v: y   / height
            ray/direction: bottom-left + (u * copy horizontal) + (v * copy vertical)
            img/(++ p): pixel-color ray
        ]
    ]
    img
][
    ;; --- Scene geometry -------------------------------------------------------
    sphere-center: #(f32![0.0 0.0 -1.0])
    sphere-radius: 0.5

    ;; --- Camera / viewport ----------------------------------------------------
    camera:      #(f32![ 0  0  0])
    bottom-left: #(f32![-1 -1 -1])
    horizontal:  #(f32![ 2  0  0])
    vertical:    #(f32![ 0  2  0])

    ;; --- Math helpers ---------------------------------------------------------
    dot: func [a b] [(a/1 * b/1) + (a/2 * b/2) + (a/3 * b/3)]
    unit-vec: func [a] [a / sqrt (a/1 * a/1) + (a/2 * a/2) + (a/3 * a/3)]

    ;; --- Ray type -------------------------------------------------------------
    ray!: make object! [
        origin:    _
        direction: _
        point-at-parameter: func [t [number!]] [origin + (direction * t)]
    ]

    ;; --- Shading --------------------------------------------------------------
    pixel-color: function [ray [object!]] [
        if hit-normal: hit-sphere ray [
            light-dir: unit-vec #(f32![-1.5 1.5 1.2])
            intensity: 0.5 * (1.0 + dot hit-normal light-dir)
            c: to integer! (255.99 * intensity)
            return to tuple! reduce [c c c]
        ]
        ;; Sky gradient
        unit-dir: unit-vec ray/direction
        c: 0.5 * (unit-dir/2 + 1.0)
        to tuple! reduce [
            to integer! (255.99 * ((1.0 - c) + (c * 0.5)))
            to integer! (255.99 * ((1.0 - c) + (c * 0.7)))
            to integer! (255.99 * ((1.0 - c) + (c * 1.0)))
        ]
    ]

    ;; --- Ray-Sphere intersection ----------------------------------------------
    hit-sphere: function [ray [object!]] [
        oc: ray/origin - sphere-center
        a:  dot ray/direction ray/direction
        b:  2.0 * dot oc ray/direction
        c:  (dot oc oc) - (sphere-radius ** 2)
        discriminant: (b ** 2) - (4 * a * c)

        if discriminant < 0 [return none]

        t: (negate b - sqrt discriminant) / (2.0 * a)
        if t > 0.001 [
            hit-point: ray/origin + (ray/direction * t)
            return unit-vec (hit-point - sphere-center)
        ]
        none
    ]
]

img: draw-sphere 400x400
browse save %draw-sphere.jpg img
