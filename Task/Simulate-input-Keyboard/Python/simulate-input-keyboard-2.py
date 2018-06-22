>>> import pyautogui
>>> pyautogui.typewrite('Hello world!')                 # prints out "Hello world!" instantly
>>> pyautogui.typewrite('Hello world!', interval=0.25)  # prints out "Hello world!" with a quarter second delay after each character
>>> pyautogui.press('enter')  # press the Enter key
>>> pyautogui.press('f1')     # press the F1 key
>>> pyautogui.press('left')   # press the left arrow key
>>> pyautogui.keyDown('shift')  # hold down the shift key
>>> pyautogui.press('left')     # press the left arrow key
>>> pyautogui.keyUp('shift')    # release the shift key
>>> pyautogui.hotkey('ctrl', 'shift', 'esc')
