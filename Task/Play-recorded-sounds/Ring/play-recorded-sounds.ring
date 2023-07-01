Load "guilib.ring"
new qapp {
         q1=NULL  q2=NULL
         win1 = new qwidget() {
                setwindowtitle("play sound!") show()
                setgeometry(100,100,400,400)
         }
         new qpushbutton(win1) {
             setgeometry(50,50,100,30)
             settext("play1")
             setclickevent("playmusic1()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(200,50,100,30)
             settext("play2")
             setclickevent("playmusic2()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(50,100,100,30)
             settext("pause1")
             setclickevent("pauseplay1()")
         show()
         }
         new qpushbutton(win1) {
             setgeometry(200,100,100,30)
             settext("pause2")
             setclickevent("pauseplay2()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(50,150,100,30)
             settext("stop1")
             setclickevent("stopplay1()")
             show()
                }
         new qpushbutton(win1) {
             setgeometry(200,150,100,30)
             settext("stop2")
             setclickevent("stopplay2()")
             show()
         }
         lineedit1 = new qlineedit(win1) {
                     setGeometry(50,200,100,30)
                     settext("50")
                     show()
         }
         lineedit2 = new qlineedit(win1) {
                     setGeometry(200,200,100,30)
                     settext("50")
                     show()
         }
         new qpushbutton(win1) {
             setgeometry(50,250,100,30)
             settext("volume1")
             setclickevent("volume1()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(200,250,100,30)
             settext("volume2")
             setclickevent("volume2()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(50,300,100,30)
             settext("mute1")
             setclickevent("mute1()")
             show()
         }
         new qpushbutton(win1) {
             setgeometry(200,300,100,30)
             settext("mute2")
             setclickevent("mute2()")
             show()
         }
         exec()
         }

func playmusic1
     q1 = new qmediaplayer(win1)  {
          setmedia(new qurl("music1.wav"))
          setvolume(50) play()
     }

func playmusic2
     q2 = new qmediaplayer(win1)  {
          setmedia(new qurl("music2.wav"))
          setvolume(50) play()
     }

func pauseplay1
     q1.pause()

func pauseplay2
     q2.pause()

func stopplay1
     q1.stop()

func stopplay2
     q2.stop()

func volume1
     lineedit1 { vol1 = text() }
     q1 {setvolume(number(vol1))}

func volume2
     lineedit2 { vol2 = text() }
     q2 {setvolume(number(vol2))}

func mute1
     q1.setmuted(true)

func mute2
     q2.setmuted(true)
