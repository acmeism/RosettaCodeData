import tkinter
import tkinter.simpledialog as tks

root = tkinter.Tk()
root.withdraw()

number = tks.askinteger("Integer", "Enter a Number")
string = tks.askstring("String", "Enter a String")

tkinter.messagebox.showinfo("Results", f"Your input:\n {number} {string}")
