-- inherited classes must be created as mixinclasses.
::class phone mixinclass object

::class camera mixinclass object

-- not a direct subclass of either, but inherits both
::class cameraphone inherit phone camera

-- could also be
::class cameraphone1 subclass phone inherit camera

-- or

::class cameraphone2 subclass camera inherit phone
