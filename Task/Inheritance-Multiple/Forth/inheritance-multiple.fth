include FMS-MIBuildGen.f
include FMS-MIHarnGen.f
include FMS-MI.f

:class Camera
;class

:class MobilePhone
;class

:class CameraPhone super{ Camera MobilePhone }  \ any number of superclasses may be used
;class

CameraPhone cf   \ instantiate a CameraPhone object named cf
