\ define class camera with method say:
:class camera
 :m say: ." camera " ;m
;class

\ define class phone with method say:
:class phone
 :m say: ." phone " ;m
;class

\ define cameraPhone phone with method say:
\ class cameraPhone inherits from both class
\ camera and class phone
:class cameraPhone super{ camera phone }
 :m say: self say: \ method conflicts in superclasses
                   \ are resolved by left-to-right order
                   \ so self say: will call the say: method
                   \ from class camera
    super> phone say: \ super> phone is used to direct
                      \ this say: method to use the
                      \ method from class phone
 ;m
;class

cameraPhone cp \ instantiate a cameraPhone object named cp

cp say: \ send the say: message to cp

\ output:
camera phone
