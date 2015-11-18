require 'gl2'
coclass 'edge'
coinsert'jgl2'

PJ=: jpath '~Projects/edges/' NB. optionally install and run as project under IDE
load PJ,'canny.ijs'

run=: 3 : 0
   wd 'pc form;pn canny'
   wd 'cc txt static;cn "Canny in J";'
   wd 'cc png isidraw'
   wd 'cc inc button;cn "Next";'
   wd 'pshow'
   glclear''
   image =: readimg_jqtide_ PJ,'valve.png'
   image =: 240 360 120 150 crop image
   edges =: canny 256 | image
   ids =: }. ~.,edges
   nids =: # ids
   case =: 0
)

form_inc_button =: 3 : 0
   select. case
   case. 0 do.
      wd 'set txt text "original image";'
      img =: 255 setalpha image
   case. 1 do.
      wd 'set txt text "points on edges";'
      img =: edges>0
      img =: 1-img
      img =: img * (+/ 256^i.3) * 255
      img =: 255 setalpha img
      ix =: 0
   case. 2 do.
      wd 'set txt text "... iterating over edges with >75 points ...";'
      img =: edges=ix{ids
      whilst. (num<75) *. (ix<nids) do.
         img =: edges=ix{ids
         num =: +/,img
         ix=:>:ix
         if. ix=#ids do. case=:_1 end.
      end.
      img =: 1-img
      img =: img * (+/ 256^i.3) * 255
      img =: 255 setalpha img
      ix =: (#ids)|(>:ix)
   end.
   if. case<2 do. case =: >: case end.
   NB. img =: 5 inflate img      NB. might need this for high-res cellphone display
   glfill 255 128 255
   glpixels 0 0,(|.$img), ,img
   glpaint''
)

form_close=: exit bind 0

run''
