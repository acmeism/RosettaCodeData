def palindromic(str):
    for i in range(len(str)//2):
        if str[i] != str[~i]:
            return(False)
    return(True)
