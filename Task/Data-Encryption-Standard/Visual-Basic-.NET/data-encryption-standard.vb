Imports System.IO
Imports System.Security.Cryptography

Module Module1

    'Taken from https://stackoverflow.com/a/311179
    Function ByteArrayToString(ba As Byte()) As String
        Return BitConverter.ToString(ba).Replace("-", "")
    End Function

    'Modified from https://stackoverflow.com/q/4100996
    'The passwordBytes parameter must be 8 bytes long
    Function Encrypt(messageBytes As Byte(), passwordBytes As Byte()) As Byte()
        Dim iv As Byte() = {&H0, &H0, &H0, &H0, &H0, &H0, &H0, &H0}

        'Set encryption settings -- Use password for both key and init. vector
        Dim provider As New DESCryptoServiceProvider
        Dim transform = provider.CreateEncryptor(passwordBytes, iv)
        Dim mode = CryptoStreamMode.Write

        'Set up streams and encrypt
        Dim memStream As New MemoryStream
        Dim cryptoStream As New CryptoStream(memStream, transform, mode)
        cryptoStream.Write(messageBytes, 0, messageBytes.Length)
        cryptoStream.FlushFinalBlock()

        'Read the encrypted message from the memory stream
        Dim encryptedMessageBytes(memStream.Length - 1) As Byte
        memStream.Position = 0
        memStream.Read(encryptedMessageBytes, 0, encryptedMessageBytes.Length)

        Return encryptedMessageBytes
    End Function

    'Modified from https://stackoverflow.com/q/4100996
    'The passwordBytes parameter must be 8 bytes long
    Function Decrypt(encryptedMessageBytes As Byte(), passwordBytes As Byte()) As Byte()
        Dim iv As Byte() = {&H0, &H0, &H0, &H0, &H0, &H0, &H0, &H0}

        'Set encryption settings -- Use password for both key and init. vector
        Dim provider As New DESCryptoServiceProvider
        Dim transform = provider.CreateDecryptor(passwordBytes, iv)
        Dim mode = CryptoStreamMode.Write

        'Set up streams and decrypt
        Dim memStream As New MemoryStream
        Dim cryptoStream As New CryptoStream(memStream, transform, mode)
        cryptoStream.Write(encryptedMessageBytes, 0, encryptedMessageBytes.Length)
        cryptoStream.FlushFinalBlock()

        'Read decrypted message from memory stream
        Dim decryptedMessageBytes(memStream.Length - 1) As Byte
        memStream.Position = 0
        memStream.Read(decryptedMessageBytes, 0, decryptedMessageBytes.Length)

        Return decryptedMessageBytes
    End Function

    Sub Main()
        Dim keyBytes As Byte() = {&HE, &H32, &H92, &H32, &HEA, &H6D, &HD, &H73}
        Dim plainBytes As Byte() = {&H87, &H87, &H87, &H87, &H87, &H87, &H87, &H87}

        Dim encStr = Encrypt(plainBytes, keyBytes)
        Console.WriteLine("Encoded: {0}", ByteArrayToString(encStr))

        Dim decStr = Decrypt(encStr, keyBytes)
        Console.WriteLine("Decoded: {0}", ByteArrayToString(decStr))
    End Sub

End Module
