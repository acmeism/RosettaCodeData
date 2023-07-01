import os

os.rename("input.txt", "output.txt")
os.rename("docs", "mydocs")

os.rename(os.sep + "input.txt", os.sep + "output.txt")
os.rename(os.sep + "docs", os.sep + "mydocs")
