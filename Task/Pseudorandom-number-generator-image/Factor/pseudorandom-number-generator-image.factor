USING: accessors images.testing images.viewer literals math
random sequences ;

CONSTANT: size 500

<rgb-image>
  ${ size size } >>dim
  size sq 3 * [ 256 random ] B{ } replicate-as >>bitmap
image-window
