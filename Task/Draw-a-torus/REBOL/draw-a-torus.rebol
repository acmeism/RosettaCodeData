Rebol [
    title: "Rosetta code: Draw a torus"
    file:  %Draw_a_torus.r3
    url:   https://rosettacode.org/wiki/Draw_a_torus
    needs: blend2d
]

draw-torus: function [
    "Draw a shaded 3D torus using perspective projection."
    canvas  [image! pair!] "Target image or dimensions to draw on"
][
    Rext: 150   ;; major radius (center of tube to center of torus)
    Rint: 60    ;; minor radius (tube cross-section radius)

    A: 0.5      ;; rotation angle around X axis (radians)
    B: 0.5      ;; rotation angle around Z axis (radians)

    ;; precompute rotation sines/cosines
    sinA: sin A  cosA: cos A
    sinB: sin B  cosB: cos B

    cx:    320  ;; canvas center X
    cy:    330  ;; canvas center Y
    scale: 600  ;; perspective scale factor
    px:    1    ;; dot radius in pixels

    drawings: copy [fill-all 0.0.0] ;; drawing commands, starting with black background
    clr: 0.0.255                    ;; reusable color tuple (R G 255)

    ;; iterate over tube angle j and revolution angle i (both 0..2π, scaled by 100)
    jj: 0.0 while [jj <= 628] [
        j: jj / 100
        ii: 0.0 while [ii <= 628] [
            i: ii / 100
            sini: sin i  cosi: cos i
            sinj: sin j  cosj: cos j

            ;; 3D point on torus surface after applying rotations A (X) and B (Z)
            h: Rext + (Rint * cosj)                         ;; distance from Z axis
            x: h * (cosB * cosi + (sinA * sinB * sini)) - (Rint * cosA * sinB * sinj)
            y: h * (sinB * cosi - (sinA * cosB * sini)) + (Rint * cosA * cosB * sinj)
            z: h * cosA * sini + (Rint * sinA * sinj)

            ;; luminance: dot product of surface normal with light direction (top-front)
            tmp: cosj * cosi * sinB - (sinA * cosj * sini * cosB) - (cosA * sinj * cosB)
            lum: 8 * (tmp - (cosi * sinj * sinA))

            if lum > 0 [
                clr/2: br: min 255 lum * 30 ;; green = brightness [0..255]
                clr/1: br / 2               ;; red   = half brightness (blue stays 255)

                ;; perspective projection onto 2D canvas
                ooz: 1 / (z + 500)          ;; reciprocal depth
                x: cx + (x * ooz * scale)
                y: cy - (y * ooz * scale)   ;; Y flipped: screen coords grow downward

                repend drawings ['fill-pen clr 'circle as-pair x y px]
            ]
            ii: ii + 3
        ]
        jj: jj + 1
    ]
    draw canvas drawings
]

browse save %Draw_a_torus.jpg draw-torus 600x600
