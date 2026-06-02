Red[
    Title: "Sphere (raytraced)"
   Author: "hinjolicious"
    Resources: "Red Sensei, Mufferaw, 'Ray Tracing in One Weekend'"
    Needs: 'View  ; Required for GUI display at the end
]

;=============================================================================
; VECTOR MATH UTILITIES
; Red's vector! type stores 3 floats (x, y, z) - perfect for 3D graphics
;=============================================================================

vec3_dot: function [a[vector!] b[vector!]] [
    ; DOT PRODUCT: Returns a scalar (single number)
    ; Measures how "aligned" two vectors are:
    ;   - Parallel vectors → large positive value
    ;   - Perpendicular → 0
    ;   - Opposite → large negative value
    ; Formula: a·b = ax*bx + ay*by + az*bz
    reduce (a/1 * b/1) + (a/2 * b/2) + (a/3 * b/3)
]

vec3_cross: function [a[vector!] b[vector!]] [
    ; CROSS PRODUCT: Returns a new vector perpendicular to both inputs
    ; Used for calculating surface normals
    ; Note: Not actually used in this simple raytracer
    reduce [ (a/2 * b/3) - (a/3 * b/2)
    negate (a/1 * b/3) - (a/3 * b/1)
    (a/1 * b/2) - (a/2 * b/1)]
]

vec3_len: function [a [vector!]][
    ; VECTOR LENGTH (magnitude): How "long" the vector is
    ; Uses Pythagorean theorem in 3D: √(x² + y² + z²)
    square-root (a/1 * a/1) + (a/2 * a/2) + (a/3 * a/3)
]

vec3_squaredlen: function [a[vector!]][
    ; SQUARED LENGTH: Faster than vec3_len (avoids square-root)
    ; Useful for comparisons where actual length isn't needed
    (a/1 * a/1) + (a/2 * a/2) + (a/3 * a/3)
]

vec3_unitvector: function [a[vector!]][
    ; NORMALIZE: Scale vector to length 1.0 (keeps direction, removes magnitude)
    ; Essential for direction calculations
    a / vec3_len a
]

;=============================================================================
; RAY OBJECT
; A ray is defined by: P(t) = origin + t * direction
; where t is the distance along the ray
;=============================================================================

ray: make object![
    origin: vector!      ; Starting point of the ray (camera position)
    direction: vector!   ; Direction the ray travels

    point_at_parameter: function [t[float!]][
        ; Find a point along the ray at distance t
        ; t=0 → origin, t=1 → one unit along direction
        origin + (direction * t)
    ]
]

;=============================================================================
; COLOR CALCULATION
; This is the heart of the raytracer - determines what color each pixel is
;=============================================================================

color: function [r [object!]][
    ; Check if ray hits the sphere centered at (0, 0, -1) with radius 0.5
    t: hit_sphere make vector![float! 32 [0.0 0.0 -1.0]] 0.5 r

    if t > 0.0 [
      ; Calculate surface normal at hit point
      n: vec3_unitvector((r/point_at_parameter t) - (make vector![float! 32 [0.0 0.0 -1.0]]))

      ; Define light direction: upper-left and toward camera
      ; Negative X = left, Positive Y = up, Positive Z = toward viewer
      light-dir: vec3_unitvector make vector! [float! 32 [-1.0 1.0 -1.5]]

      ; Calculate lighting intensity using dot product
      ; Surfaces facing the light are bright, facing away are dark
      ;intensity: vec3_dot n light-dir

      ; Use Half-Lambert:
      raw: vec3_dot n light-dir
      intensity: (raw * 0.5) + 0.5  ; remaps [-1,1] to [0,1]
      intensity: intensity * intensity  ; optional: slight darkening

      ; Clamp to avoid negative values (surfaces facing away from light)
      if intensity < 0.0 [intensity: 0.0]

      ;ambient: 0.1  ; adjust to taste (0.1 - 0.3 typical)
      ;intensity: ambient + ((1.0 - ambient) * intensity)  ; blend ambient with diffuse

      gamma: 0.45  ; typical value (1/2.2)
      intensity: intensity ** gamma  ; apply before creating the vector

      ; Return white sphere with shading
      return make vector! reduce ['float! 32 reduce [intensity intensity intensity]]
      ;return (n + 1) * 0.5
    ]

    ; RAY MISSED - draw sky background gradient
    unit_direction: vec3_unitvector r/direction

    ; t varies from 0.0 (bottom) to 1.0 (top) based on ray's Y direction
    t: 0.5 * unit_direction/2 + 1.0

    ; Linear interpolation (lerp) between white and light blue
    ; When t=0: pure white (1,1,1)
    ; When t=1: light blue (0.5, 0.7, 1.0)
    (make vector! [float! 32 [ 1.0 1.0 1.0]]) * (1.0 - t)  + ((make vector! [float! 32 [0.5 0.7 1.0]]) * t)
]

;=============================================================================
; RAY-SPHERE INTERSECTION
; Uses the quadratic formula to find where ray intersects sphere
;=============================================================================

hit_sphere: function [center[vector!] radius[float!] ray[object!]][
    ; Vector from ray origin to sphere center
    oc: ray/origin - center

    ; Quadratic equation coefficients: at² + bt + c = 0
    ; Derived from: |P(t) - center|² = radius²
    a: vec3_dot r/direction r/direction      ; Usually 1.0 if direction is normalized
    b: 2.0 * vec3_dot oc ray/direction       ; Linear term
    c: vec3_dot oc oc - (radius ** 2)        ; Constant term

    ; Discriminant determines number of intersections:
    ;   < 0: No intersection (ray misses sphere)
    ;   = 0: Ray grazes sphere (one point)
    ;   > 0: Ray passes through sphere (two points)
    discriminant: b ** 2 - (4 * a * c)

    either discriminant < 0 [
        return -1.0  ; No hit - signal with negative value
    ][
        ; Return the nearest intersection point (smaller t value)
        ; Using quadratic formula: t = (-b - √discriminant) / 2a
        return (negate b - square-root discriminant) / (2.0 * a)
    ]
]

;=============================================================================
; CAMERA & VIEWPORT SETUP
;=============================================================================

nx: 200  ; Image width in pixels
ny: 200  ; Image height in pixels

; Define the virtual "screen" in 3D space that we shoot rays through
; The camera looks down the -Z axis (standard convention)
lower_left_corner: make vector! [float! 32 [-1.0 -1.0 -1.0]]  ; Bottom-left of viewport
vertical: make vector! [float! 32 [0.0 2.0 0.0]]              ; Viewport height vector
origin: make vector! [float! 32 [0.0 0.0 0.0]]                ; Camera position
horizontal: make vector! [float! 32 [2.0 0.0 0.0]]            ; Viewport width vector

;=============================================================================
; MAIN RENDERING LOOP
; Shoots one ray per pixel, collects colors into img block
;=============================================================================

img: []  ; Will store all pixel colors as tuples

repeat jj ny [
    ; Flip Y coordinate (render top-to-bottom, but image coords are bottom-to-top)
    j: ny - jj + 1

    repeat i nx [
        ; Calculate normalized UV coordinates (0.0 to 1.0)
        u: to float! i / to float! nx  ; Horizontal position
        v: to float! j / to float! ny  ; Vertical position

        ; Create a ray from camera through this pixel's position on viewport
        r: copy ray
        r/origin: copy origin
        ; Ray direction = lower_left + u*horizontal + v*vertical
        ; This maps (u,v) to a point on the viewport plane
        r/direction: copy lower_left_corner + ((copy horizontal) * u) + ((copy vertical) * v)

        ; Get the color for this ray
        col: color copy r

        ; Convert float colors (0.0-1.0) to integer RGB (0-255)
        ; 255.99 instead of 255 to handle edge case of exactly 1.0
        ir: to integer! 255.99 * col/1  ; Red
        ig: to integer! 255.99 * col/2  ; Green
        ib: to integer! 255.99 * col/3  ; Blue

        ; Store as tuple! (Red's native color type)
        ; The 4th value (0) is alpha channel
        append img make tuple! reduce [ir ig ib 0]
    ]
]

;=============================================================================
; CREATE IMAGE AND DISPLAY
;=============================================================================

; Create empty image with our dimensions
pic: make image! make pair! reduce[nx ny]

; Copy all calculated pixel colors into the image
repeat i length? pic [pic/:i: img/:i]

; Display result in a GUI window
view [
    title "Sphere (raytraced)"
    size 220x220
    image pic
]
