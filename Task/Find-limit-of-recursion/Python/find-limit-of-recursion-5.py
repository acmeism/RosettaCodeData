def recurseDeeper(counter):
    try:
        print(counter)
        recurseDeeper(counter + 1)
    except RecursionError:
        print("RecursionError at depth", counter)
        recurseDeeper(counter + 1)
