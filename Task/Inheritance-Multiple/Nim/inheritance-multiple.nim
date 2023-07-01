type
  Camera = ref object of RootObj
  MobilePhone = ref object of RootObj
  CameraPhone = object
    camera: Camera
    phone: MobilePhone
proc `is`(cp: CameraPhone, t: typedesc): bool =
  for field in cp.fields():
    if field of t:
      return true
var cp: CameraPhone
echo(cp is Camera)
echo(cp is MobilePhone)
