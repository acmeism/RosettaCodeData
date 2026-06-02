Red[
    Title: "Deathstar (raytraced)"
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

color: function [ray [object!]][
    hit: hit-death-star ray
    if hit [
        n: hit/normal
        ; Half-Lambert shading
        ;light-dir: vec3_unitvector make vector! [float! 32 [1.5 1.5 -1.2]] ;upper-right
      light-dir: vec3_unitvector make vector! [float! 32 [-1.5 1.5 1.2]] ;upper-left-back light
        intensity: 0.5 * (1.0 + vec3_dot n light-dir)
        return make vector! reduce ['float! 32 reduce [intensity intensity intensity]]
    ]
    ; Background gradient
    unit-dir: vec3_unitvector ray/direction
    t: 0.5 * (unit-dir/2 + 1.0)
    return make vector! reduce ['float! 32 reduce [
        (1.0 - t) + (t * 0.5)
        (1.0 - t) + (t * 0.7)
        (1.0 - t) + (t * 1.0)
    ]]
]

;=============================================================================
; RAY-SPHERE INTERSECTION
; Uses the quadratic formula to find where ray intersects sphere
;=============================================================================

; Death Star parameters
death-star-center: make vector! [float! 32 [0.0 0.0 -1.0]]
death-star-radius: 0.5

; Dent sphere (positioned to intersect the main sphere surface)
dent-center: make vector! [float! 32 [-0.4 0.4 -1.3]]  ; offset toward camera and upper-left
dent-radius: 0.5

; Check if a point is inside a sphere
point-inside-sphere: function [point [vector!] center [vector!] radius [float!]][
    diff: point - center
    dist-sq: (diff/1 * diff/1) + (diff/2 * diff/2) + (diff/3 * diff/3)
    return dist-sq < (radius * radius)
]

; Modified hit function for Death Star
hit-death-star: function [ray [object!]][
    ; Get both intersection points with main sphere (entry and exit)
    oc: ray/origin - death-star-center
    a: vec3_dot ray/direction ray/direction
    b: 2.0 * vec3_dot oc ray/direction
    c: (vec3_dot oc oc) - (death-star-radius ** 2)
    discriminant: (b ** 2) - (4 * a * c)

    if discriminant < 0 [return none]

    sqrt-disc: square-root discriminant

    ; Try near intersection first
    t1: (negate b - sqrt-disc) / (2.0 * a)
    if t1 > 0.001 [
        hit-point: ray/origin + (ray/direction * t1)
        unless point-inside-sphere hit-point dent-center dent-radius [
            ; Valid hit on outer surface
            return reduce ['t t1 'point hit-point 'normal vec3_unitvector (hit-point - death-star-center)]
        ]
    ]

    ; Near point was inside dent, try far intersection
    t2: (b + sqrt-disc) / (2.0 * a)
    if t2 > 0.001 [
        hit-point: ray/origin + (ray/direction * t2)
        unless point-inside-sphere hit-point dent-center dent-radius [
            return reduce ['t t2 'point hit-point 'normal vec3_unitvector (hit-point - death-star-center)]
        ]
    ]

    ; Check if ray hits the dent's inner surface
    oc2: ray/origin - dent-center
    a2: vec3_dot ray/direction ray/direction
    b2: 2.0 * vec3_dot oc2 ray/direction
    c2: (vec3_dot oc2 oc2) - (dent-radius ** 2)
    disc2: (b2 ** 2) - (4 * a2 * c2)

    if disc2 >= 0 [
        t-dent: (negate b2 + square-root disc2) / (2.0 * a2)  ; far side of dent sphere
        if t-dent > 0.001 [
            hit-point: ray/origin + (ray/direction * t-dent)
            if point-inside-sphere hit-point death-star-center death-star-radius [
                ; Inside main sphere = valid dent surface
                ; Normal points INWARD (toward dent center) for concave surface
                return reduce ['t t-dent 'point hit-point 'normal vec3_unitvector (dent-center - hit-point)]
            ]
        ]
    ]

    return none
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
    title "Deathstar (raytraced)"
    size 220x220
    image pic
]
