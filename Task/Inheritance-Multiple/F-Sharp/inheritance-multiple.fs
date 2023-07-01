type Picture = System.Drawing.Bitmap // (a type synonym)

// an interface type
type Camera =
  abstract takePicture : unit -> Picture

// an interface that inherits multiple interfaces
type Camera2 =
  inherits System.ComponentModel.INotifyPropertyChanged
  inherits Camera

// a class with an abstract method with a default implementation
// (usually called a virtual method)
type MobilePhone() =
  abstract makeCall : int[] -> unit
  default x.makeCall(number) = () // empty impl

// a class that inherits from another class and implements an interface
type CameraPhone() =
  inherit MobilePhone()
  interface Camera with
    member x.takePicture() = new Picture(10, 10)
