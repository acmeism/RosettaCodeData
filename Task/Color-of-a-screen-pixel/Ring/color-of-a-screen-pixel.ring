# Project : Color of a screen pixel

Load "gamelib.ring"
r = 0
g = 0
b = 0
al_init()
al_init_image_addon()
display = al_create_display(1000,800)
al_set_target_bitmap(al_get_backbuffer(display))
al_clear_to_color(al_map_rgb(255,255,255))
image = al_load_bitmap("stock.jpg")
al_draw_rotated_bitmap(image,0,0,250,250,150,0)
al_draw_scaled_bitmap(image,0,0,250,250,20,20,400,400,0)
ring_getpixel(image,300,300)
see "r = " + r + nl
see "g = " + g + nl
see "b = " + b + nl
al_flip_display()
al_rest(2)
al_destroy_bitmap(image)
al_destroy_display(display)

func ring_getpixel(image,x,y)
       newcolor = al_get_pixel(image,x,y)
       r=copy(" ",4)  g=copy(" ",4)  b=copy(" ",4)
       p1 = VarPtr("r","float")
       p2 = VarPtr("g","float")
       p3 = VarPtr("b","float")
       al_unmap_rgb_f(newcolor, p1 , p2 , p3 )
       r = bytes2float(r)
       g = bytes2float(g)
       b = bytes2float(b)
       return [r,g,b]
