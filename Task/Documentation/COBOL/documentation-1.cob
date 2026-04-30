      *>****L* cobweb/cobweb-gtk [0.2]
      *> Author:
      *>   Author details
      *> Colophon:
      *>   Part of the GnuCobol free software project
      *>   Copyright (C) 2014 person
      *>   Date      20130308
      *>   Modified  20141003
      *>   License   GNU General Public License, GPL, 3.0 or greater
      *>   Documentation licensed GNU FDL, version 2.1 or greater
      *>   HTML Documentation thanks to ROBODoc --cobol
      *> Purpose:
      *> GnuCobol functional bindings to GTK+
      *> Main module includes paperwork output and self test
      *> Synopsis:
      *> |dotfile cobweb-gtk.dot
      *> |html <br />
      *> Functions include
      *> |exec cobcrun cobweb-gtk >cobweb-gtk.repository
      *> |html <pre>
      *> |copy cobweb-gtk.repository
      *> |html </pre>
      *> |exec rm cobweb-gtk.repository
      *> Tectonics:
      *>   cobc -v -b -g -debug cobweb-gtk.cob voidcall_gtk.c
      *>        `pkg-config --libs gtk+-3.0` -lvte2_90 -lyelp
      *>   robodoc --cobol --src ./ --doc cobwebgtk --multidoc --rc robocob.rc --css cobodoc.css
      *>   cobc -E -Ddocpass cobweb-gtk.cob
      *>   make singlehtml  # once Sphinx set up to read cobweb-gtk.i
      *> Example:
      *>  COPY cobweb-gtk-preamble.
      *>  procedure division.
      *>  move TOP-LEVEL to window-type
      *>  move 640 to width-hint
      *>  move 480 to height-hint
      *>  move new-window("window title", window-type,
      *>      width-hint, height-hint)
      *>    to gtk-window-data
      *>  move gtk-go(gtk-window) to extraneous
      *>  goback.
      *> Notes:
      *>  The interface signatures changed between 0.1 and 0.2
      *> Screenshot:
      *> image:cobweb-gtk1.png
      *> Source:
       REPLACE ==FIELDSIZE== BY ==80==
               ==AREASIZE==  BY ==32768==
               ==FILESIZE==  BY ==65536==.

id     identification division.
       program-id. cobweb-gtk.

       ...

done   goback.
       end program cobweb-gtk.
      *>****
