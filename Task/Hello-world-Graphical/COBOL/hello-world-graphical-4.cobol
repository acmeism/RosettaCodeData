      *>
      *> cobweb-gui-hello, using gtk-label
      *> Tectonics:
      *>   cobc -w -xj cobweb-gui-hello.cob cobweb-gtk.cob \
      *>        `pkg-config --libs gtk+-3.0`
      *>
       identification division.
       program-id. cobweb-gui-hello.

       environment division.
       configuration section.
       repository.
           function new-window
           function new-box
           function new-label
           function gtk-go
           function all intrinsic.

       data division.
       working-storage section.

       01 TOPLEVEL                     usage binary-long value 0.
       01 HORIZONTAL                   usage binary-long value 0.
       01 VERTICAL                     usage binary-long value 1.

       01 width-hint                   usage binary-long value 160.
       01 height-hint                  usage binary-long value 16.

       01 spacing                      usage binary-long value 8.
       01 homogeneous                  usage binary-long value 0.

       01 extraneous                   usage binary-long.

       01 gtk-window-data.
          05 gtk-window                usage pointer.
       01 gtk-container-data.
          05 gtk-container             usage pointer.

       01 gtk-box-data.
          05 gtk-box                   usage pointer.
       01 gtk-label-data.
          05 gtk-label                 usage pointer.

       procedure division.
       cobweb-hello-main.

      *> Main window and top level container
       move new-window("Hello", TOPLEVEL, width-hint, height-hint)
         to gtk-window-data
       move new-box(gtk-window, VERTICAL, spacing, homogeneous)
         to gtk-container-data

      *> Box, across, with simple label
       move new-box(gtk-container, HORIZONTAL, spacing, homogeneous)
         to gtk-box-data
       move new-label(gtk-box, "Goodbye, World!") to gtk-label-data

      *> GTK+ event loop now takes over
       move gtk-go(gtk-window) to extraneous

       goback.
       end program cobweb-gui-hello.
