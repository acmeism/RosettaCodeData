fn SphereHit(comptime T: type) type {
    return struct { z1: T, z2: T };
}
