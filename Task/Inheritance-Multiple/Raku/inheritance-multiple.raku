class Camera {}
class MobilePhone {}
class CameraPhone is Camera is MobilePhone {}

say CameraPhone.^mro;     # undefined type object
say CameraPhone.new.^mro; # instantiated object
