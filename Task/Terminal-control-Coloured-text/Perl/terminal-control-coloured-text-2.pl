#ON WINDOWS USING POWERSHELL or WT.EXE
$ForegroundColor = {
    BLACK    		=> "\e[1;30m",
    DARK_RED 		=> "\e[1;31m",
    DARK_GREEN 		=> "\e[1;32m",
    DARK_YELLOW		=> "\e[1;33m",
    DARK_BLUE		=> "\e[1;34m",
    DARK_MAGENTA	=> "\e[1;35m",
    DARK_CYAN		=> "\e[1;36m",
    LIGHT_GREY		=> "\e[1;37m",
    DARK_GREY		=> "\e[1;90m",
    RED			=> "\e[1;91m",
    GREEN		=> "\e[1;92m",
    YELLOW		=> "\e[1;93m",
    BLUE		=> "\e[1;94m",
    MAGENTA		=> "\e[1;95m",
    CYAN		=> "\e[1;96m",
    WHITE		=> "\e[1;97m"
};
$BackgroundColor = {
    BLACK    		=> "\e[1;40m",
    DARK_RED 		=> "\e[1;41m",
    DARK_GREEN 		=> "\e[1;42m",
    DARK_YELLOW		=> "\e[1;43m",
    DARK_BLUE		=> "\e[1;44m",
    DARK_MAGENTA	=> "\e[1;45m",
    DARK_CYAN		=> "\e[1;46m",
    LIGHT_GREY		=> "\e[1;47m",
    DARK_GREY		=> "\e[1;100m",
    RED			=> "\e[1;101m",
    GREEN		=> "\e[1;102m",
    YELLOW		=> "\e[1;103m",
    BLUE		=> "\e[1;104m",
    MAGENTA		=> "\e[1;105m",
    CYAN		=> "\e[1;106m",
    WHITE		=> "\e[1;107m"
};
$ClearColors = "\e[1;0m";

print $ForegroundColor->{WHITE};
print $BackgroundColor->{DARK_BLUE};
print "White On Blue";
print $ClearColors;
