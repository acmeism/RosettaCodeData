def truncate_file(name, length):
    if not os.path.isfile(name):
        return False
    if length >= os.path.getsize(name):
        return False
    with open(name, 'ab') as f:
        f.truncate(length)
        f.close()
        return True
