import win32api
import win32con
import pywintypes
devmode=pywintypes.DEVMODEType()
devmode.PelsWidth=640
devmode.PelsHeight=480
devmode.Fields=win32con.DM_PELSWIDTH | win32con.DM_PELSHEIGHT
win32api.ChangeDisplaySettings(devmode,0)
