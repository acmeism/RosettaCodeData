       identification division.
       program-id. x11-hello.
       installation. cobc -x x11-hello.cob -lX11
       remarks. Use of private data is likely not cross platform.

       data division.
       working-storage section.
       01 msg.
          05 filler            value z"S'up, Earth?".
       01 msg-len              usage binary-long value 12.

       01 x-display            usage pointer.
       01 x-window             usage binary-c-long.

      *> GnuCOBOL does not evaluate C macros, need to peek at opaque
      *> data from Xlib.h
      *> some padding is added, due to this comment in the header
      *> "there is more to this structure, but it is private to Xlib"
       01 x-display-private    based.
          05 x-ext-data        usage pointer sync.
          05 private1          usage pointer.
          05 x-fd              usage binary-long.
          05 private2          usage binary-long.
          05 proto-major-version   usage binary-long.
          05 proto-minor-version   usage binary-long.
          05 vendor            usage pointer sync.
          05 private3          usage pointer.
          05 private4          usage pointer.
          05 private5          usage pointer.
          05 private6          usage binary-long.
          05 allocator         usage program-pointer sync.
          05 byte-order        usage binary-long.
          05 bitmap-unit       usage binary-long.
          05 bitmap-pad        usage binary-long.
          05 bitmap-bit-order  usage binary-long.
          05 nformats          usage binary-long.
          05 screen-format     usage pointer sync.
          05 private8          usage binary-long.
          05 x-release         usage binary-long.
          05 private9          usage pointer sync.
          05 private10         usage pointer sync.
          05 qlen              usage binary-long.
          05 last-request-read usage binary-c-long unsigned sync.
          05 request           usage binary-c-long unsigned sync.
          05 private11         usage pointer sync.
          05 private12         usage pointer.
          05 private13         usage pointer.
          05 private14         usage pointer.
          05 max-request-size  usage binary-long unsigned.
          05 x-db              usage pointer sync.
          05 private15         usage program-pointer sync.
          05 display-name      usage pointer.
          05 default-screen    usage binary-long.
          05 nscreens          usage binary-long.
          05 screens           usage pointer sync.
          05 motion-buffer     usage binary-c-long unsigned.
          05 private16         usage binary-c-long unsigned.
          05 min-keycode       usage binary-long.
          05 max-keycode       usage binary-long.
          05 private17         usage pointer sync.
          05 private18         usage pointer.
          05 private19         usage binary-long.
          05 x-defaults        usage pointer sync.
          05 filler            pic x(256).

       01 x-screen-private     based.
          05 scr-ext-data      usage pointer sync.
          05 display-back      usage pointer.
          05 root              usage binary-c-long.
          05 x-width           usage binary-long.
          05 x-height          usage binary-long.
          05 m-width           usage binary-long.
          05 m-height          usage binary-long.
          05 x-ndepths         usage binary-long.
          05 depths            usage pointer sync.
          05 root-depth        usage binary-long.
          05 root-visual       usage pointer sync.
          05 default-gc        usage pointer.
          05 cmap              usage pointer.
          05 white-pixel       usage binary-c-long unsigned sync.
          05 black-pixel       usage binary-c-long unsigned.
          05 max-maps          usage binary-long.
          05 min-maps          usage binary-long.
          05 backing-store     usage binary-long.
          05 save_unders       usage binary-char.
          05 root-input-mask   usage binary-c-long sync.
          05 filler            pic x(256).

       01 event.
          05 e-type usage      binary-long.
          05 filler            pic x(188).
          05 filler            pic x(256).
       01 Expose               constant as 12.
       01 KeyPress             constant as 2.

      *> ExposureMask or-ed with KeyPressMask, from X.h
       01 event-mask           usage binary-c-long value 32769.

      *> make the box around the message wide enough for the font
       01 x-char-struct.
          05 lbearing          usage binary-short.
          05 rbearing          usage binary-short.
          05 string-width      usage binary-short.
          05 ascent            usage binary-short.
          05 descent           usage binary-short.
          05 attributes        usage binary-short unsigned.
       01 font-direction       usage binary-long.
       01 font-ascent          usage binary-long.
       01 font-descent         usage binary-long.

       01 XGContext            usage binary-c-long.
       01 box-width            usage binary-long.
       01 box-height           usage binary-long.

      *> ***************************************************************
       procedure division.

       call "XOpenDisplay" using by reference null returning x-display
           on exception
               display function module-id " Error: "
                       "no XOpenDisplay linkage, requires libX11"
                  upon syserr
               stop run returning 1
       end-call
       if x-display equal null then
           display function module-id " Error: "
                   "XOpenDisplay returned null" upon syserr
           stop run returning 1
       end-if
       set address of x-display-private to x-display

       if screens equal null then
           display function module-id " Error: "
                   "XOpenDisplay associated screen null" upon syserr
           stop run returning 1
       end-if
       set address of x-screen-private to screens

       call "XCreateSimpleWindow" using
           by value x-display root 10 10 200 50 1
                    black-pixel white-pixel
           returning x-window
       call "XStoreName" using
           by value x-display x-window by reference msg

       call "XSelectInput" using by value x-display x-window event-mask

       call "XMapWindow" using by value x-display x-window

       call "XGContextFromGC" using by value default-gc
           returning XGContext
       call "XQueryTextExtents" using by value x-display XGContext
           by reference msg by value msg-len
           by reference font-direction font-ascent font-descent
           x-char-struct
       compute box-width = string-width + 8
       compute box-height = font-ascent + font-descent + 8

       perform forever
          call "XNextEvent" using by value x-display by reference event
          if e-type equal Expose then
              call "XDrawRectangle" using
                  by value x-display x-window default-gc 5 5
                           box-width box-height
              call "XDrawString" using
                  by value x-display x-window default-gc 10 20
                  by reference msg by value msg-len
          end-if
          if e-type equal KeyPress then exit perform end-if
       end-perform

       call "XCloseDisplay" using by value x-display

       goback.
       end program x11-hello.
