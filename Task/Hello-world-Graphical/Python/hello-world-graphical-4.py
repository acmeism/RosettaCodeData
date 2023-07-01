import PyQt4.QtGui
app = PyQt4.QtGui.QApplication([])
pb = PyQt4.QtGui.QPushButton('Hello World')
pb.connect(pb,PyQt4.QtCore.SIGNAL("clicked()"),pb.close)
pb.show()
exit(app.exec_())
