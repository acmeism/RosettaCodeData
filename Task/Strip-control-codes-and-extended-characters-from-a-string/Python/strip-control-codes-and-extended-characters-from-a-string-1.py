stripped = lambda s: "".join(i for i in s if 31 < ord(i) < 127)

print(stripped("\ba\x00b\n\rc\fd\xc3"))
