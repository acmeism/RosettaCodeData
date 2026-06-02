struct Camera {}

impl Camera {
    fn snap(self) { println "Taking a photo."; }
}

struct Phone {}

impl Phone {
    fn call(self) { println "Calling home."; }
}

struct CameraPhone {
    use camera : Camera;
    use phone  : Phone;
}

fn main() {
    let cp = CameraPhone{camera: Camera{}, phone: Phone{}};
    cp.camera.snap();
    cp.phone.call();
}
