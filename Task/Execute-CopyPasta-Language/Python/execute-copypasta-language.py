import sys

# a function to handle fatal errors
def fatal_error(errtext):
	print("%" + errtext)
	print("usage: " + sys.argv[0] + " [filename.cp]")
	sys.exit(1)

# get a filename from the command line and read the file in
fname = None
source = None
try:
	fname = sys.argv[1]
	source = open(fname).read()
except:
	fatal_error("error while trying to read from specified file")

# convert the source to lines of code
lines = source.split("\n")

# a variable to represent the 'clipboard'
clipboard = ""

# loop over the lines that were read
loc = 0
while(loc < len(lines)):
	# check which command is on this line
	command = lines[loc].strip()

	try:
		if(command == "Copy"):
			clipboard += lines[loc + 1]
		elif(command == "CopyFile"):
			if(lines[loc + 1] == "TheF*ckingCode"):
				clipboard += source
			else:
				filetext = open(lines[loc+1]).read()
				clipboard += filetext
		elif(command == "Duplicate"):
			clipboard += clipboard * ((int(lines[loc + 1])) - 1)
		elif(command == "Pasta!"):
			print(clipboard)
			sys.exit(0)
		else:
			fatal_error("unknown command '" + command + "' encountered on line " + str(loc + 1))
	except Exception as e:
		fatal_error("error while executing command '" + command + "' on line " + str(loc + 1) + ": " + e)

	# increment past the command and the next line
	loc += 2
