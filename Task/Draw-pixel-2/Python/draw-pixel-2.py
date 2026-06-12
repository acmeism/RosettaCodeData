import Tkinter,random
def draw_pixel_2 ( sizex=640,sizey=480 ):
    pos  = random.randint( 0,sizex-1 ),random.randint( 0,sizey-1 )
    root = Tkinter.Tk()
    can  = Tkinter.Canvas( root,width=sizex,height=sizey,bg='black' )
    can.create_rectangle( pos*2,outline='yellow' )
    can.pack()
    root.title('press ESCAPE to quit')
    root.bind('<Escape>',lambda e : root.quit())
    root.mainloop()

draw_pixel_2()
