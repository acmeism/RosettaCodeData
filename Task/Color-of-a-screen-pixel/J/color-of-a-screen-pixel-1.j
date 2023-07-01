GetDC=:        'user32.dll GetDC >i i'&cd NB. hdx: GetDC hwnd
GetPixel=:     'gdi32.dll  GetPixel >l i i i'&cd NB. rgb: GetPixel hdc x y
GetCursorPos=: 'user32.dll GetCursorPos i *i'&cd NB. success: point
