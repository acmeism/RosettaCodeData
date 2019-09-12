Number.metaClass.mixin RationalCategory

[
    0.9054054, 0.518518, 0.75, Math.E, -0.423310825, Math.PI, 0.111111111111111111111111
].each{
    printf "%30.27f %s\n", it, it as Rational
}
