' Demonstrate a simple Windows/Linux application using GTK/FreeBasic

#INCLUDE "gtk/gtk.bi"

gtk_init(@__FB_ARGC__, @__FB_ARGV__)

VAR win = gtk_window_new (GTK_WINDOW_TOPLEVEL)
gtk_window_set_title (gtk_window (win), "Goodbye, World")
g_signal_connect(G_OBJECT (win), "delete-event", @gtk_main_quit, 0)
gtk_widget_show_all (win)

gtk_main()

END 0
