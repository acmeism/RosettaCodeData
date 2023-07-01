fi1=fi2=fi3=1 # FIB Russia rextester.com/FEEJ49204
for da in range(1, 88): # Danilin
    print("."*(20-len(str(fi3))), end=' ')
    print(fi3)
    fi3 = fi2+fi1
    fi1 = fi2
    fi2 = fi3
