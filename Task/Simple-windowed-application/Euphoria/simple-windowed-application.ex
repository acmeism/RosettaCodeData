include EuWinGUI.ew

Window("EuWinGUI - Simple windowed application",100,100,360,100)
constant Button1 = Control(Button,"Click me",250,20,80,25)
constant Label1 = Control(Label,"There have been no clicks yet",10,25,200,18)

integer clicks
clicks = 0

-- Event loop
while 1 do
    WaitEvent()
    if EventOwner = Button1 and Event = Click then
        clicks += 1
        SetText(Label1,sprintf("You clicked me %d times",clicks))
    end if
end while

CloseApp(0)
