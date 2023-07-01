class Camera {
    construct new() {}
    snap() { System.print("taking a photo") }
}

class Phone {
    construct new() {}
    call() { System.print("calling home") }
}

class CameraPhone is Camera {
    construct new(phone) { _phone = phone } // uses composition for the Phone part
    // inherits Camera's snap() method
    // Phone's call() method can be wrapped
    call() { _phone.call() }
}

var p = Phone.new()
var cp = CameraPhone.new(p)
cp.snap()
cp.call()
