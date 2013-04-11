import wx

class MyApp(wx.App):
  def click(self, event):
    self.count += 1
    self.label.SetLabel("Count: %d" % self.count)

  def OnInit(self):
    frame = wx.Frame(None, wx.ID_ANY, "Hello from wxPython")
    self.count = 0
    self.button = wx.Button(frame, wx.ID_ANY, "Click me!")
    self.label = wx.StaticText(frame, wx.ID_ANY, "Count: 0")
    self.Bind(wx.EVT_BUTTON, self.click, self.button)

    self.sizer = wx.BoxSizer(wx.VERTICAL)
    self.sizer.Add(self.button, True, wx.EXPAND)
    self.sizer.Add(self.label, True, wx.EXPAND)
    frame.SetSizer(self.sizer)
    frame.SetAutoLayout(True)
    self.sizer.Fit(frame)

    frame.Show(True)

    self.SetTopWindow(frame)
    return True

app = MyApp(0)
app.MainLoop()
