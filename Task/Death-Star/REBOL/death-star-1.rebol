Rebol [
    title: "Rosetta code: Death Star"
    file:  %Death_Star.r3
    url:   https://rosettacode.org/wiki/Death_Star
]

death-star: function/with [size [pair!]][
    width: size/x  height: size/y  p: 1
    img: make image! size
    ray: make ray! [origin: camera]
    repeat row height [
        ;; Flip Y so we render top-to-bottom (image origin is bottom-left)
        y: height - row + 1
        repeat col width [
            ;; Normalize pixel (col, y) to UV in [0.0, 1.0]
            u: col / width
            v: y   / height
            ;; Cast a ray from the camera through this UV point on the viewport plane
            ray/direction: bottom-left + (u * copy horizontal) + (v * copy vertical)
            img/(++ p): pixel-color ray
        ]
    ]
    img ;= result
][
    ;; --- Scene geometry -------------------------------------------------------
    death-star-center: #(f32![0.0 0.0 -1.0])    ;; Main sphere, centred on the -Z axis
    death-star-radius: 0.5

    dent-center: #(f32![-0.4 0.4 -1.3])         ;; Dent sphere: offset upper-left and
    dent-radius: 0.5                            ;;   slightly behind the main sphere

    ;; --- Camera / viewport ----------------------------------------------------
    ;; A simple pinhole camera looking down -Z.
    ;; Rays are formed by linearly interpolating across the viewport rectangle.
    camera:      #(f32![ 0  0  0])   ;; Eye position (world origin)
    bottom-left: #(f32![-1 -1 -1])   ;; World-space corner of the viewport plane
    horizontal:  #(f32![ 2  0  0])   ;; Full width vector of the viewport (X axis)
    vertical:    #(f32![ 0  2  0])   ;; Full height vector of the viewport (Y axis)

    ;; --- Math helpers ---------------------------------------------------------
    dot: func [a b] [(a/1 * b/1) + (a/2 * b/2) + (a/3 * b/3)]
    unit-vec: func [a] [a / sqrt (a/1 * a/1) + (a/2 * a/2) + (a/3 * a/3)]

    ;; --- Ray type -------------------------------------------------------------
    ray!: make object! [
        origin:    _   ;; Ray start (camera position)
        direction: _   ;; Ray direction (not required to be unit-length)
        ;; Returns the 3-D point at distance t along the ray: P = O + t*D
        point-at-parameter: func [t [number!]] [origin + (direction * t)]
    ]

    ;; --- Shading --------------------------------------------------------------
    pixel-color: function [ray [object!]] [
        if hit-normal: hit-death-star ray [
            ;; Half-Lambert diffuse: remaps dot(N, L) from [-1, 1] to [0, 1]
            ;; so the dark side is 0% rather than negative.
            light-dir: unit-vec #(f32![-1.5 1.5 1.2])   ;; Upper-left-back light
            intensity: 0.5 * (1.0 + dot hit-normal light-dir)
            c: to integer! (255.99 * intensity)
            return to tuple! reduce [c c c]
        ]
        ;; No hit -- draw a vertical blue-to-white sky gradient
        unit-dir: unit-vec ray/direction
        c: 0.5 * (unit-dir/2 + 1.0)   ;; Map Y component [-1, 1] to [0, 1]
        to tuple! reduce [
            to integer! (255.99 * ((1.0 - c) + (c * 0.5)))   ;; R: white to mid-grey
            to integer! (255.99 * ((1.0 - c) + (c * 0.7)))   ;; G: white to light blue
            to integer! (255.99 * ((1.0 - c) + (c * 1.0)))   ;; B: white to full blue
        ]
    ]

    ;; Returns true if `point` lies strictly inside the sphere (center, radius)
    point-inside-sphere: function [point [vector!] center [vector!] radius [number!]] [
        diff: point - center
        dist-sq: (diff/1 * diff/1) + (diff/2 * diff/2) + (diff/3 * diff/3)
        dist-sq < (radius * radius)   ;; Compare squared distances to avoid a sqrt
    ]

    ;; --- Ray-Death Star intersection ------------------------------------------
    ;; The Death Star is a sphere with a spherical dent carved out of it.
    ;; We implement CSG (Constructive Solid Geometry) manually:
    ;;   visible surface = main sphere MINUS dent sphere
    ;;
    ;; Strategy:
    ;;   1. Solve the quadratic for the main sphere and test both roots (t1 <= t2).
    ;;   2. Use the nearest root whose hit-point is NOT inside the dent sphere.
    ;;   3. If both roots are occluded by the dent, check whether the ray hits
    ;;      the far side of the dent sphere while still inside the main sphere;
    ;;      that far-side surface is the concave inner wall of the dent.
    hit-death-star: function [ray [object!]] [
        ;; -- Intersect main sphere ---------------------------------------------
        ;; Quadratic: |O + tD - C|^2 = r^2  =>  at^2 + bt + c = 0
        oc: ray/origin - death-star-center
        a:  dot ray/direction ray/direction
        b:  2.0 * dot oc ray/direction
        c:  (dot oc oc) - (death-star-radius ** 2)
        discriminant: (b ** 2) - (4 * a * c)

        if discriminant < 0 [return none]   ;; Ray misses the main sphere entirely
        sqrt-disc: sqrt discriminant

        ;; t1 = near intersection (smaller t)
        t1: (negate b - sqrt-disc) / (2.0 * a)
        if t1 > 0.001 [   ;; 0.001 offset avoids self-intersection artefacts
            hit-point: ray/origin + (ray/direction * t1)
            unless point-inside-sphere hit-point dent-center dent-radius [
                ;; Front surface is outside the dent -- outward normal
                return unit-vec (hit-point - death-star-center)
            ]
        ]

        ;; t2 = far intersection (larger t); try if near point was inside the dent
        t2: (b + sqrt-disc) / (2.0 * a)   ;; note: sign flip vs. t1
        if t2 > 0.001 [
            hit-point: ray/origin + (ray/direction * t2)
            unless point-inside-sphere hit-point dent-center dent-radius [
                ;; Back surface is also outside the dent -- outward normal
                return unit-vec (hit-point - death-star-center)
            ]
        ]
        ;; -- Intersect the concave dent wall -----------------------------------
        ;; Both main-sphere hits were masked by the dent.
        ;; Solve the quadratic for the dent sphere and take its FAR root (t-dent);
        ;; that is the inner surface the ray exits through after entering the dent.
        oc2: ray/origin - dent-center
        a2:  dot ray/direction ray/direction
        b2:  2.0 * dot oc2 ray/direction
        c2:  (dot oc2 oc2) - (dent-radius ** 2)
        disc2: (b2 ** 2) - (4 * a2 * c2)

        if disc2 >= 0 [
            ;; Far root of dent sphere: use + branch of the quadratic
            t-dent: (negate b2 + sqrt disc2) / (2.0 * a2)
            if t-dent > 0.001 [
                hit-point: ray/origin + (ray/direction * t-dent)
                if point-inside-sphere hit-point death-star-center death-star-radius [
                    ;; Hit-point is inside the main sphere => it's on the dent wall.
                    ;; Normal faces INWARD (toward dent center) for the concave surface.
                    return unit-vec (dent-center - hit-point)
                ]
            ]
        ]
        none   ;; Ray passes through the dent without hitting any visible surface
    ]
]

img: death-star 400x400
browse save %Death_Star.jpg img
