open System
open System.Security.Cryptography
open System.IO

let ByteArrayToString ba =
    ba |> Array.map (fun (b : byte) -> b.ToString("X2")) |> String.Concat

let Encrypt passwordBytes messageBytes =
    // Configure encryption settings
    let iv = Array.zeroCreate 8
    let provider = new DESCryptoServiceProvider()
    let transform = provider.CreateEncryptor(passwordBytes, iv)

    // Setup streams and encrypt
    let memStream = new MemoryStream()
    let cryptoStream = new CryptoStream(memStream, transform, CryptoStreamMode.Write)
    cryptoStream.Write(messageBytes, 0, messageBytes.Length)
    cryptoStream.FlushFinalBlock()

    // Read the encrypted message from the stream
    let encryptedMessageBytes = Array.zeroCreate ((int) memStream.Length)
    memStream.Position <- 0L
    memStream.Read(encryptedMessageBytes, 0, encryptedMessageBytes.Length) |> ignore

    // Return the encrypted bytes
    encryptedMessageBytes

let Decrypt passwordBytes encryptedBytes =
    // Configure encryption settings
    let iv = Array.zeroCreate 8
    let provider = new DESCryptoServiceProvider()
    let transform = provider.CreateDecryptor(passwordBytes, iv)

    // Setup streams and decrypt
    let memStream = new MemoryStream()
    let cryptoStream = new CryptoStream(memStream, transform, CryptoStreamMode.Write)
    cryptoStream.Write(encryptedBytes, 0, encryptedBytes.Length)
    cryptoStream.FlushFinalBlock()

    // Read the message from the stream
    let messageBytes = Array.zeroCreate ((int) memStream.Length)
    memStream.Position <- 0L
    memStream.Read(messageBytes, 0, messageBytes.Length) |> ignore

    // Return the encrypted bytes
    messageBytes

[<EntryPoint>]
let main _ =
    let keyBytes = [|0x0euy; 0x32uy; 0x92uy; 0x32uy; 0xeauy; 0x6duy; 0x0duy; 0x73uy|]
    let plainbytes = [|0x87uy; 0x87uy; 0x87uy; 0x87uy; 0x87uy; 0x87uy; 0x87uy; 0x87uy|]

    let encStr = Encrypt keyBytes plainbytes
    printfn "Encoded: %s" (ByteArrayToString encStr)

    let decBytes = Decrypt keyBytes encStr
    printfn "Decoded: %s" (ByteArrayToString decBytes)

    0 // return an integer exit code
