Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
Key      = "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN"

def encrypt(str) = str.tr(Alphabet, Key)
def decrypt(str) = str.tr(Key, Alphabet)

str = 'All is lost, he thought. Everything is ruined. It’s ten past three.'
p encrypted =   encrypt(str)
p decrypt(encrypted)
