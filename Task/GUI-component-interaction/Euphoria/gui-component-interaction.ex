include GtkEngine.e -- see OpenEuphoria.org

constant -- interface
    win = create(GtkWindow,"title=GUI Component Interaction;size=200x100;border=10;$destroy=Quit"),
    pan = create(GtkBox,"orientation=vertical;spacing=10"),
    inp = create(GtkEntry,"name=Input;text=0;$activate=Validate"),
    box = create(GtkButtonBox),
    btn1 = create(GtkButton,"gtk-add#_Increment","Increment"),
    btn2 = create(GtkButton,"gtk-help#_Random","Random")

add(win,pan)
add(pan,inp)
add(box,{btn1,btn2})
pack(pan,-box)

show_all(win)
main()

-----------------------------
global function Validate() -- warns about invalid entry, does not prevent it;
-----------------------------
if not t_digit(trim_head(get("Input.text"),"- ")) then
    return Warn(win,"Validate","This is not a valid number","Try again!")
end if
return 1
end function

---------------------------
global function Increment()
---------------------------
set("Input.value",get("Input.value")+1)
return 1
end function

------------------------
global function Random()
------------------------
if Question(win,"Random","Click OK for a random number",,GTK_BUTTONS_OK_CANCEL) = MB_OK then
    set("Input.value",rand(1000))
end if
return 1
end function
