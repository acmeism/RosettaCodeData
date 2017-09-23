   require 'viewmat'
   require 'media/platimg'       NB. addon required pre J8
   Img=: readimg_jqtide_ jpath '~temp/pentagon.png'
   viewmat 460 360 houghTransform _1 > Img
