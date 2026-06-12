let msg = "Rosetta code Bacon cipher example secret phrase to encode in the capitalisation of peter pan"
    enc = BaconCipher.encrypt(msg)
    dec = BaconCipher.decrypt(enc)
    println("\nOriginal:\n", msg)
    println(" -> Encrypted:\n", enc)
    println(" -> Decrypted:\n", dec)
end
