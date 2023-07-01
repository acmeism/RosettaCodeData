import sys, datetime, shutil

if len(sys.argv) == 1:
    try:
        with open("notes.txt", "r") as f:
            shutil.copyfileobj(f, sys.stdout)
    except IOError:
        pass
else:
    with open("notes.txt", "a") as f:
        f.write(datetime.datetime.now().isoformat() + "\n")
        f.write("\t%s\n" % ' '.join(sys.argv[1:]))
