from functools import partial

import tkinter as tk


def on_click(label: tk.Label,
             counter: tk.IntVar) -> None:
    counter.set(counter.get() + 1)
    label["text"] = f"Number of clicks: {counter.get()}"


def main():
    window = tk.Tk()
    label = tk.Label(master=window,
                     text="There have been no clicks yet")
    label.pack()
    counter = tk.IntVar()
    update_counter = partial(on_click,
                             label=label,
                             counter=counter)
    button = tk.Button(master=window,
                       text="click me",
                       command=update_counter)
    button.pack()
    window.mainloop()


if __name__ == '__main__':
    main()
