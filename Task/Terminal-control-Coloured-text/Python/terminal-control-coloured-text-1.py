from colorama import init, Fore, Back, Style
init(autoreset=True)

print Fore.RED + "FATAL ERROR! Cannot write to /boot/vmlinuz-3.2.0-33-generic"
print Back.BLUE + Fore.YELLOW + "What a cute console!"
print "This is an %simportant%s word" % (Style.BRIGHT, Style.NORMAL)
print Fore.YELLOW  + "Rosetta Code!"
print Fore.CYAN    + "Rosetta Code!"
print Fore.GREEN   + "Rosetta Code!"
print Fore.MAGENTA + "Rosetta Code!"
print Back.YELLOW + Fore.BLUE + Style.BRIGHT + " " * 40 + " == Good Bye!"
