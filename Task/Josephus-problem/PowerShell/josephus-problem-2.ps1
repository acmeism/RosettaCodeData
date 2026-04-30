#  Get the prisoner order for a circle of 41 prisoners, selecting every third
$Prisoners = Get-JosephusPrisoners -N 41 -K 3

#  Display the prisoner order
$Prisoners -join " "

#  Display the last remaining prisoner
"Last prisoner remmaining: " + $Prisoners[-1]

#  Display the last three remaining prisoners
$S = 3
"Last $S remaining: " + $Prisoners[-$S..-1]
