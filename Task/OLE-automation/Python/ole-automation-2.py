import win32com.client
client = win32com.client.Dispatch("python.server")
client.write("hello world")
