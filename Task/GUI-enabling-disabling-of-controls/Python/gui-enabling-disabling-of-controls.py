#!/usr/bin/env python3

import tkinter as tk

class MyForm(tk.Frame):

    def __init__(self, master=None):
        tk.Frame.__init__(self, master)
        self.pack(expand=True, fill="both", padx=10, pady=10)
        self.master.title("Controls")
        self.setupUI()

    def setupUI(self):
        self.value_entry = tk.Entry(self, justify=tk.CENTER)
        self.value_entry.grid(row=0, column=0, columnspan=2,
                              padx=5, pady=5, sticky="nesw")
        self.value_entry.insert('end', '0')
        self.value_entry.bind("<KeyPress-Return>", self.eventHandler)

        self.decre_btn = tk.Button(self, text="Decrement", state=tk.DISABLED)
        self.decre_btn.grid(row=1, column=0, padx=5, pady=5)
        self.decre_btn.bind("<Button-1>", self.eventHandler)

        self.incre_btn = tk.Button(self, text="Increment")
        self.incre_btn.grid(row=1, column=1, padx=5, pady=5)
        self.incre_btn.bind("<Button-1>", self.eventHandler)

    def eventHandler(self, event):
        value = int(self.value_entry.get())
        if event.widget == self.value_entry:
            if value > 10:
                self.value_entry.delete("0", "end")
                self.value_entry.insert("end", "0")
            elif value == 10:
                self.value_entry.config(state=tk.DISABLED)
                self.incre_btn.config(state=tk.DISABLED)
                self.decre_btn.config(state=tk.NORMAL)
            elif value == 0:
                self.value_entry.config(state=tk.NORMAL)
                self.incre_btn.config(state=tk.NORMAL)
                self.decre_btn.config(state=tk.DISABLED)
            elif (value > 0) and (value < 10):
                self.value_entry.config(state=tk.DISABLED)
                self.incre_btn.config(state=tk.NORMAL)
                self.decre_btn.config(state=tk.NORMAL)
        else:
            if event.widget == self.incre_btn:
                if (value >= 0) and (value < 10):
                    value += 1
                    self.value_entry.config(state=tk.NORMAL)
                    self.value_entry.delete("0", "end")
                    self.value_entry.insert("end", str(value))
                if value > 0:
                    self.decre_btn.config(state=tk.NORMAL)
                    self.value_entry.config(state=tk.DISABLED)
                if value == 10:
                    self.incre_btn.config(state=tk.DISABLED)
            elif event.widget == self.decre_btn:
                if (value > 0) and (value <= 10):
                    value -= 1
                    self.value_entry.config(state=tk.NORMAL)
                    self.value_entry.delete("0", "end")
                    self.value_entry.insert("end", str(value))
                    self.value_entry.config(state=tk.DISABLED)
                if (value) < 10:
                    self.incre_btn.config(state=tk.NORMAL)
                if (value) == 0:
                    self.decre_btn.config(state=tk.DISABLED)
                    self.value_entry.config(state=tk.NORMAL)

def main():
    app = MyForm()
    app.mainloop()

if __name__ == "__main__":
    main()
