# Project : Audio frequency generator

Load "guilib.ring"
loadlib("C:\Ring\extensions\ringbeep\ringbeep.dll")

freq = 1000
ImageFile  = "stock.jpg"

    UserIcons = CurrentDir() +"\"

    WinLeft   = 80
    WinTop    = 80
    WinWidth  = 1200
    WinHeight = 750
    WinRight  = WinLeft + WinWidth
    WinBottom = WinTop  + WinHeight

    BoxLeft   = 80
    BoxTop    = 40
    BoxWidth  = WinWidth  -160
    BoxHeight = WinHeight -100
    imageW = 400 ;  imageH = 400 ; GrowBy = 8
    volume = 100

MyApp = New qapp
{

    win1 = new qMainWindow()
    {
            setwindowtitle("Video and Music Player")
            setgeometry( WinLeft, WinTop, WinWidth, WinHeight)

             if Fexists(ImageFile)

                imageStock = new qlabel(win1)
                {
                    image = new qpixmap(ImageFile)
                    AspectRatio = image.width() / image.height()

                    imageW = 1000
                    imageH = 600

                    setpixmap(image.scaled(imageW , imageH ,0,0))
                    PosLeft = (BoxWidth  - imageW ) / 2 + 80
                    PosTop  = (BoxHeight - imageH ) / 2 +40
                    setGeometry(PosLeft,PosTop,imageW,imageH)

                }

            else
                msg = "ImageFile: -- "+ ImageFile +" -- required. Use an Image JPG of your choice"
                SendMsg(msg)
            ok

            videowidget = new qVideoWidget(win1)
            {
                setgeometry(BoxLeft, BoxTop, BoxWidth, BoxHeight)
                setstylesheet("background-color: green")
            }

            player = new qMediaPlayer()
            {
               setVideoOutput(videowidget)
            }

            TimerDuration = new qTimer(win1)
            {
                setinterval(1000)
                settimeoutevent("pTimeDuration()")  ### ==>> func
                start()
            }

            oFont = new qFont("",10,0,0)
            setFont( oFont)

            btnBack = new qpushbutton(win1)    {
                    setGeometry(280,20,80,20)
                    settext("Low")
                    seticon(new qicon(new qpixmap(UserIcons +"Backward.png")))
                    setclickevent( "pBackward()")
            }

            btnDur = new qpushbutton(win1)    {
                    setGeometry(360,20,140,20)
            }

            btnFwd = new qpushbutton(win1)    {
                    setGeometry(500,20,80,20)
                    settext("High")
                    seticon(new qicon(new qpixmap(UserIcons +"Forward.png")))
                    setclickevent( "pForward()")
            }

            btnVolume = new qpushbutton(win1)    {
                setGeometry(760,20,100,20)
                settext("Volume: 100")
                seticon(new qicon(new qpixmap(UserIcons +"Volume.png")))
            }

            VolumeDec = new qpushbutton(win1)
            {
                setgeometry(700,20,60,20)
                settext("Low")
                seticon(new qicon(new qpixmap(UserIcons +"VolumeLow.png")))
                setclickevent( "PVolumeDec()")
            }

            VolumeInc = new qpushbutton(win1)
            {
                setgeometry(860,20,60,20)
                settext("High")
                seticon(new qicon(new qpixmap(UserIcons +"VolumeHigh.png")))
                setclickevent( "pVolumeInc()")
            }

        show()

    }

     exec()
}

Func pTimeDuration()
    Duration()
return

Func Duration()

    DurPos = "Frequency: " + string(freq) + " Hz"
    btnDur.setText(DurPos)

return

Func pForward
    freq = freq + 100
    for n = 1 to 3
         beep(freq,300)
    next
return

Func pBackward
    freq = freq - 100
    for n = 1 to 3
         beep(freq,300)
    next
return

Func pVolumeDec()
    if volume > 0
       volume = volume - 10
       btnVolume.settext("Volume: " + volume)
       player.setVolume(volume)
    ok
return

Func pVolumeInc()
    if volume < 100
       volume = volume + 10
       btnVolume.settext("Volume: " + volume)
       player.setVolume(volume)
    ok
return
