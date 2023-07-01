#!/usr/bin/env python3

import tkinter as tk # import the module.

root = tk.Tk() # Create an instance of the class.
root.state('zoomed') # Maximized the window.
root.update_idletasks() # Update the display.
tk.Label(root, text=(str(root.winfo_width())+ " x " +str(root.winfo_height())),
         font=("Helvetica", 25)).pack() # add a label and set the size to text.
root.mainloop()
