dim as integer i, w, h, d

for i = 0 to 21
    if i>2 and i<7 then continue for    'screens 3-6 are not defined
    screen i
    screeninfo w, h, d
    print "Screen ";i
    print using "#### x ####, color depth ##";w;h;d
    sleep
next i

'a more flexible alternative is ScreenRes

'this sets up a window of 1618x971 pixels, colour depth 8, and 2 pages
screenres 1618, 971, 8, 2
windowtitle "Foo bar baz"
sleep


'see https://documentation.help/FreeBASIC/KeyPgScreengraphics.html
'for more information
