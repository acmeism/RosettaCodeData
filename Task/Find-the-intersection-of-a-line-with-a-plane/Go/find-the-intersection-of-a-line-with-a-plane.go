package main

import "fmt"

type Vector3D struct{ x, y, z float64 }

func (v *Vector3D) Add(w *Vector3D) *Vector3D {
    return &Vector3D{v.x + w.x, v.y + w.y, v.z + w.z}
}

func (v *Vector3D) Sub(w *Vector3D) *Vector3D {
    return &Vector3D{v.x - w.x, v.y - w.y, v.z - w.z}
}

func (v *Vector3D) Mul(s float64) *Vector3D {
    return &Vector3D{s * v.x, s * v.y, s * v.z}
}

func (v *Vector3D) Dot(w *Vector3D) float64 {
    return v.x*w.x + v.y*w.y + v.z*w.z
}

func (v *Vector3D) String() string {
    return fmt.Sprintf("(%v, %v, %v)", v.x, v.y, v.z)
}

func intersectPoint(rayVector, rayPoint, planeNormal, planePoint *Vector3D) *Vector3D {
    diff := rayPoint.Sub(planePoint)
    prod1 := diff.Dot(planeNormal)
    prod2 := rayVector.Dot(planeNormal)
    prod3 := prod1 / prod2
    return rayPoint.Sub(rayVector.Mul(prod3))
}

func main() {
    rv := &Vector3D{0.0, -1.0, -1.0}
    rp := &Vector3D{0.0, 0.0, 10.0}
    pn := &Vector3D{0.0, 0.0, 1.0}
    pp := &Vector3D{0.0, 0.0, 5.0}
    ip := intersectPoint(rv, rp, pn, pp)
    fmt.Println("The ray intersects the plane at", ip)
}
