import pyautogui

pyautogui.moveTo(100, 200)      # moves mouse to X of 100, Y of 200.
pyautogui.moveTo(None, 500)     # moves mouse to X of 100, Y of 500.
pyautogui.moveTo(600, None)     # moves mouse to X of 600, Y of 500.
pyautogui.moveTo(100, 200, 2)   # moves mouse to X of 100, Y of 200 over 2 seconds

pyautogui.moveRel(0, 50)        # move the mouse down 50 pixels.
pyautogui.moveRel(-30, 0)       # move the mouse left 30 pixels.

pyautogui.click()                          # Left button click on current position
pyautogui.click(clicks=2)
pyautogui.click(clicks=2, interval=0.25)   # with a quarter second pause in between clicks

pyautogui.click(10, 5)                     # Mouse left button click, x=10, y=5
pyautogui.click(200, 250, button='right')  # Mouse right button click, x=200, y=250

pyautogui.scroll(10)   # scroll up 10 "clicks"
pyautogui.scroll(10, x=100, y=100)  # move mouse cursor to 100, 200, then scroll up 10 "clicks"
