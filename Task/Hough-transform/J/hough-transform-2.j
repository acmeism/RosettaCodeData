   require 'viewmat media/platimg'
   Img=: readimg jpath '~temp/pentagon.png'
   viewmat 460 360 houghTransform _1 > Img
