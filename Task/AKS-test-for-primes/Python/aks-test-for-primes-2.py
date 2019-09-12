def aks(p):
    if p==2:return True
    c=1
    for i in range(p//2+1):
        c=c*(p-i)//(i+1)
        if c%p:return False
    return True
