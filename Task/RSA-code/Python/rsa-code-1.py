from tkinter import *
import random
import time

letter = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q",
          "r","s","t","u","v","w","x","y","z",",",".","!","?",' ']
number = ["01","02","03","04","05","06","07","08","09","10","11","12","13",
          "14","15","16","17","18","19","20","21","22","23","24","25","26","27",
          "28","29","30",'31']

n = 2537
e = 13
d = 937
def decrypt(F,d):
    # performs the decryption function on an block of ciphertext
    if d == 0:
        return 1
    if d == 1:
        return F
    w,r = divmod(d,2)
    if r == 1:
        return decrypt(F*F%n,w)*F%n
    else:
        return decrypt(F*F%n,w)

def correct():
    # Checks to see if the numerical ciphertext block should have started with a 0 (by seeing if the 0 is missing), if it is, it then adds the 0.
    # example - 0102 is output as 102, which would lead the computer to think the first letter is 10, not 01. This ensures this does not happen.
    for i in range(len(D)):
        if len(str(P[i]))%2 !=0:
            y = str(0)+str(P[i])
            P.remove(str(P[i]))
            P.insert(i,y)

def cipher(b,e):
    # Performs the Encryption function on a block of ciphertext
    if e == 0:
        return 1
    if e == 1:
        return b
    w,r = divmod(e,2)
    if r == 1:
        return cipher(b*b%n,w)*b%n
    else:
        return cipher(b*b%n,w)

def group(j,h,z):
    # Places the plaintext numbers into blocks for encryption
    for i in range(int(j)):
        y = 0
        for n in range(h):
            y += int(numP[(h*i)+n])*(10**(z-2*n))
        X.append(int(y))



class App:
    # Creates a Tkineter window, for ease of operation
    def __init__(self, master):

        frame = Frame(master)
        frame.grid()

        #create a button with the quit command, and tell it where to go
        quitbutton = Button(frame, text = "quit", fg ="red",
                            command = root.quit, width = 10)
        quitbutton.grid(row = 0, column =3)

        #create an entry box, tell it where it goes, and how large it is
        entry = Entry(frame, width = 100)
        entry.grid(row = 0, column = 0)

        #set initial content of the entry box
        self.contents = StringVar()
        self.contents.set("Type message here")
        entry["textvariable"] = self.contents

        # Create a button which initializes the decryption of ciphertext
        decrypt = Button(frame,text = "Decrypt", fg = "blue",
                         command = self.Decrypt)
        decrypt.grid(row = 2, column = 1)

        #create a label to display the number of ciphertext blocks in an encoded message
        label = Label(frame, text = "# of blocks")
        label.grid(row = 1, column = 1)

        #creates a button which initializes the encryption of plaintext
        encrypt = Button(frame, text="Encrypt", fg = "blue",
                         command = self.Encrypt)
        encrypt.grid(row =0, column =1)

        #create an entry box for the value of "n"
        nbox = Entry(frame, width = 100)
        nbox.grid(row = 3, column = 0)

        self.n = StringVar()
        self.n.set(n)
        nbox["textvar"] = self.n
        nbox.bind('<Key-Return>', self.set_n)           #key binding, when you press "return", the value of "n" is changed to the value now in the box

        nlabel = Label(frame, text = "the value of 'n'")
        nlabel.grid(row = 3, column = 1)

        #create an entry box for the value of "e"
        ebox = Entry(frame, width = 100)
        ebox.grid(row = 4, column = 0)

        self.e = StringVar()
        self.e.set(e)
        ebox["textvar"] = self.e
        ebox.bind('<Key-Return>', self.set_e)

        elabel = Label(frame, text = "the value of 'e'")
        elabel.grid(row = 4, column = 1)

        #create an entry box for the value of "d"
        dbox = Entry(frame, width = 100)
        dbox.grid(row =5, column = 0)

        self.d = StringVar()
        self.d.set(d)
        dbox["textvar"] = self.d
        dbox.bind('<Key-Return>', self.set_d)

        dlabel = Label(frame, text = "the value of 'd'")
        dlabel.grid(row = 5, column =1)

        blocks = Label(frame, width = 100)
        blocks.grid(row = 1, column =0)

        self.block = StringVar()
        self.block.set("number of blocks")
        blocks["textvar"] = self.block

        output = Entry(frame, width = 100)
        output.grid(row = 2, column = 0)

        self.answer = StringVar()
        self.answer.set("Ciphertext")
        output["textvar"] = self.answer

    # The commands of all the buttons are defined below
    def set_n(self,event):
        global n
        n = int(self.n.get())
        print("n set to", n)

    def set_e(self, event):
        global e
        e = int(self.e.get())
        print("e set to",e)

    def set_d(self,event):
        global d
        d = int(self.d.get())
        print("d set to", d)

    def Decrypt(self):
        #decrypts an encoded message
        global m,P,D,x,h,p,Text,y,w,PText
        P = []
        D = str(self.answer.get())              #Pulls the ciphertext out of the ciphertext box
        D = D.lstrip('[')                       #removes the bracket "[" from the left side of the string
        D = D.rstrip(']')
        D = D.split(',')                        #splits the string into a list of strings, separating at each comma.
        for i in range(len(D)):                 #decrypts each block in the list of strings "D"
            x = decrypt(int(D[i]),d)
            P.append(str(x))
        correct()                               #ensures each block is not missing a 0 at the start
        h = len(P[0])
        p = []
        for i in range(len(D)):                 #further separates the list P into individual characters, i.e. "0104" becomes "01,04"
            for n in range(int(h/2)):
                p.append(str(P[i][(2*n):((2*n)+2)]))  # grabs every 2 character group from the larger block. It gets characters between 2*n, and (2*n)+2, i.e. characters 0,1 then 2,3 etc...

        Text = []
        for i in range(len(p)):                 # converts each block back to text characters
            for j in range(len(letter)):
                if str(p[i]) == number[j]:
                    Text.append(letter[j])
        PText = str()
        for i in range(len(Text)):              #places all text characters in one string
            PText = PText + str(Text[i])
        self.contents.set(str(PText))           #places the decrypted plaintext in the plaintext box


    def Encrypt(self):
        #encrypts a plaintext message using the current key
        global plaintext,numP,q,j,z,X,C
        plaintext = self.contents.get()              #pulls the plaintext out of the entry box for use
        plaintext = plaintext.lower()                #places all plaintext in lower case
        numP = []
        for i in range(len(plaintext)):              # converts letters and symbols to their numerical values
            for j in range(len(letter)):
                if plaintext[i] == letter[j]:
                    numP.append(number[j])
        h = (len(str(n))//2)-1                       # This sets the block length for the code in question, based on the value of "n"
        q = len(numP)%h
        for i in range(h-q):
            numP.append(number[random.randint(0,25)])   # Ensures the final block of plaintext is filled with letters, and is not a single orphaned letter.
        j = len(numP) / h
        X = []
        z = 0
        for m in range(h-1):
            z+=2
        group(j,h,z)                                 # This sets the numerical plaintext into blocks of appropriate size, and places them in the list "X"
        k = len(X)
        C = []
        for i in range(k):                           # performs the cipher function for each block in the list of plaintext blocks
            b = X[i]
            r = cipher(b,e)
            C.append(r)
        self.answer.set(C)
        self.block.set(len(C))                      #places the ciphertext into the ciphertext box


root = Tk()

app = App(root)

root.mainloop()
root.destroy()
