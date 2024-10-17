use std::ops::{Add, Div, Mul, Sub};

#[derive(Copy, Clone, Debug, PartialEq)]
struct V3<T> {
    x: T,
    y: T,
    z: T,
}

impl<T> V3<T> {
    fn new(x: T, y: T, z: T) -> Self {
        V3 { x, y, z }
    }
}

fn zip_with<F, T, U>(f: F, a: V3<T>, b: V3<T>) -> V3<U>
where
    F: Fn(T, T) -> U,
{
    V3 {
        x: f(a.x, b.x),
        y: f(a.y, b.y),
        z: f(a.z, b.z),
    }
}

impl<T> Add for V3<T>
where
    T: Add<Output = T>,
{
    type Output = Self;

    fn add(self, other: Self) -> Self {
        zip_with(<T>::add, self, other)
    }
}

impl<T> Sub for V3<T>
where
    T: Sub<Output = T>,
{
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        zip_with(<T>::sub, self, other)
    }
}

impl<T> Mul for V3<T>
where
    T: Mul<Output = T>,
{
    type Output = Self;

    fn mul(self, other: Self) -> Self {
        zip_with(<T>::mul, self, other)
    }
}

impl<T> V3<T>
where
    T: Mul<Output = T> + Add<Output = T>,
{
    fn dot(self, other: Self) -> T {
        let V3 { x, y, z } = self * other;
        x + y + z
    }
}

impl<T> V3<T>
where
    T: Mul<Output = T> + Copy,
{
    fn scale(self, scalar: T) -> Self {
        self * V3 {
            x: scalar,
            y: scalar,
            z: scalar,
        }
    }
}

fn intersect<T>(
    ray_vector: V3<T>,
    ray_point: V3<T>,
    plane_normal: V3<T>,
    plane_point: V3<T>,
) -> V3<T>
where
    T: Add<Output = T> + Sub<Output = T> + Mul<Output = T> + Div<Output = T> + Copy,
{
    let diff = ray_point - plane_point;
    let prod1 = diff.dot(plane_normal);
    let prod2 = ray_vector.dot(plane_normal);
    let prod3 = prod1 / prod2;
    ray_point - ray_vector.scale(prod3)
}

fn main() {
    let rv = V3::new(0.0, -1.0, -1.0);
    let rp = V3::new(0.0, 0.0, 10.0);
    let pn = V3::new(0.0, 0.0, 1.0);
    let pp = V3::new(0.0, 0.0, 5.0);
    println!("{:?}", intersect(rv, rp, pn, pp));
}
