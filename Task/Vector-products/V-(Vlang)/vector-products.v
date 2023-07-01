struct Vector {
    x f64
    y f64
    z f64
}

const (
    a = Vector{3, 4, 5}
    b = Vector{4, 3, 5}
    c = Vector{-5, -12, -13}
)

fn dot(a Vector, b Vector) f64 {
    return a.x*b.x + a.y*b.y + a.z*b.z
}

fn cross(a Vector, b Vector) Vector {
    return Vector{a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x}
}

fn s3(a Vector, b Vector, c Vector) f64 {
    return dot(a, cross(b, c))
}

fn v3(a Vector, b Vector, c Vector) Vector {
    return cross(a, cross(b, c))
}

fn main() {
    println(dot(a, b))
    println(cross(a, b))
    println(s3(a, b, c))
    println(v3(a, b, c))
}
