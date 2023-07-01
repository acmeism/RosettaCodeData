PROGRAM firstgtk CONTEXT VOID
USE standard
BEGIN
MODE GDATA = REF BITS;
MODE GUINT = BITS;
MODE GSIZE = BITS;
MODE GTYPE = GSIZE;
MODE GTYPECLASS = STRUCT(GTYPE g type);
MODE GTYPEINSTANCE = STRUCT(REF GTYPECLASS g class);
MODE GTKWIDGETPRIVATE = REF BITS;

MODE GOBJECT = STRUCT(
                GTYPEINSTANCE g type instance,
                GUINT ref count,
                REF GDATA qdata);

MODE GTKWIDGET = STRUCT(
                GOBJECT parent instance,
      REF GTKWIDGETPRIVATE priv);

PROC(REF INT,REF CCHARPTRPTR)VOID gtk init = ALIEN "GTK_INIT"
        "#define GTK_INIT(argc,argv) gtk_init(argc,argv)";
PROC(INT)REF GTKWIDGET gtk window new = ALIEN "GTK_WINDOW_NEW"
        "#define GTK_WINDOW_NEW(type) (void *)gtk_window_new(type)";
PROC(REF GTKWIDGET)VOID gtk widget show = ALIEN "GTK_WIDGET_SHOW"
        "#define GTK_WIDGET_SHOW(widget) gtk_widget_show((void *)widget)";
PROC gtk main = VOID: CODE "gtk_main();";

INT gtk window toplevel = 0;
FILE argf;
REF GTKWIDGET window;

open(argf,"",arg channel);
gtk init(argc,argv);
window:=gtk window new(gtk window toplevel);
gtk widget show(window);
gtk main
END
FINISH
