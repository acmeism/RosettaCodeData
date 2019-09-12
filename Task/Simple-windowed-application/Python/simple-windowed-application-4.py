import wx


class ClickCounter(wx.Frame):
    def __init__(self):
        super().__init__(parent=None)
        self.count = 0
        self.button = wx.Button(parent=self,
                                label="Click me!")
        self.label = wx.StaticText(parent=self,
                                   label="There have been no clicks yet")
        self.Bind(event=wx.EVT_BUTTON,
                  handler=self.click,
                  source=self.button)

        self.sizer = wx.BoxSizer(wx.VERTICAL)
        self.sizer.Add(window=self.button,
                       proportion=1,
                       flag=wx.EXPAND)
        self.sizer.Add(window=self.label,
                       proportion=1,
                       flag=wx.EXPAND)
        self.SetSizer(self.sizer)
        self.sizer.Fit(self)

    def click(self, _):
        self.count += 1
        self.label.SetLabel(f"Count: {self.count}")


if __name__ == '__main__':
    app = wx.App()
    frame = ClickCounter()
    frame.Show()
    app.MainLoop()
