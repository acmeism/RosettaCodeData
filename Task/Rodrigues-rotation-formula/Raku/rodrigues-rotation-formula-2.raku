sub infix:<•> { sum @^v1 Z× @^v2 } # dot product

sub infix:<❌> (@v1, @v2) {         # cross product
    my \a = <1 2 0>; my \b = <2 0 1>;
    @v1[a] »×« @v2[b] »-« @v1[b] »×« @v2[a]
}

sub norm (*@v) { sqrt @v • @v }

sub normal (*@v) { @v X/ @v.&norm }

sub angle-between (@v1, @v2) { acos( (@v1 • @v2) / (@v1.&norm × @v2.&norm) ) }

sub infix:<⁢> is equiv(&infix:<×>) { $^a × $^b } # invisible times

sub postfix:<°> (\d) { d × τ / 360 } # degrees to radians

sub rodrigues-rotate( @point, @axis, $θ ) {
    my ( \cos𝜃, \sin𝜃 ) = cis($θ).reals;
    my ( \𝑥, \𝑦, \𝑧 )   = @axis;
    my \𝑡 = 1 - cos𝜃;

    map @point • *, [
       [ 𝑥²⁢𝑡 + cos𝜃, 𝑦⁢𝑥⁢𝑡 - 𝑧⁢sin𝜃, 𝑧⁢𝑥⁢𝑡 + 𝑦⁢sin𝜃 ],
       [ 𝑥⁢𝑦⁢𝑡 + 𝑧⁢sin𝜃, 𝑦²⁢𝑡 + cos𝜃, 𝑧⁢𝑦⁢𝑡 - 𝑥⁢sin𝜃 ],
       [ 𝑥⁢𝑧⁢𝑡 - 𝑦⁢sin𝜃, 𝑦⁢𝑧⁢𝑡 + 𝑥⁢sin𝜃, 𝑧²⁢𝑡 + cos𝜃 ]
    ]
}

sub point-vector (@point, @vector) {
    rodrigues-rotate @point, normal(@point ❌ @vector), angle-between @point, @vector
}

put qq:to/TESTING/;
Task example - Point and composite axis / angle:
{ point-vector [5, -6, 4], [8, 5, -30] }

Perhaps more useful, (when calculating a range of motion for a robot appendage,
for example), feeding a point, axis of rotation and rotation angle separately;
since theoretically, the point vector and axis of rotation should be constant:

{
(0, 10, 20 ... 180).map( { # in degrees
    sprintf "Rotated %3d°: %.13f, %.13f, %.13f", $_,
    rodrigues-rotate [5, -6, 4], ([5, -6, 4] ❌ [8, 5, -30]).&normal, .°
}).join: "\n"
}
TESTING
