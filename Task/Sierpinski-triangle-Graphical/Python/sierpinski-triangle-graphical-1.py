# a very simple version
import turtle as t
def sier(n,length):
    if n == 0:
        return
    for i in range(3):
        sier(n - 1, length / 2)
        t.fd(length)
        t.rt(120)
