interface alloc_img
   module procedure alloc_img_rgb, alloc_img_sc
end interface

interface free_img
   module procedure free_img_rgb, free_img_sc
end interface
