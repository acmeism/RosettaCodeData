import hashlib
h = hashlib.sha1()
h.update(bytes("Ars longa, vita brevis", encoding="ASCII"))
h.hexdigest()
# "e640d285242886eb96ab80cbf858389b3df52f43"
