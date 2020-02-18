module Crc32 =

    open System

    // Generator polynomial (modulo 2) for the reversed CRC32 algorithm.
    let private s_generator = uint32 0xEDB88320

    // Generate lookup table
    let private lutIntermediate input =
        if (input &&& uint32 1) <> uint32 0
        then s_generator ^^^ (input >>> 1)
        else input >>> 1

    let private lutEntry input =
        {0..7}
        |> Seq.fold (fun acc x -> lutIntermediate acc) input

    let private crc32lut =
        [uint32 0 .. uint32 0xFF]
        |> List.map lutEntry

    let crc32byte (register : uint32) (byte : byte) =
        crc32lut.[Convert.ToInt32((register &&& uint32 0xFF) ^^^ Convert.ToUInt32(byte))] ^^^ (register >>> 8)

    // CRC32 of a byte array
    let crc32 (input : byte[]) =
        let result = Array.fold crc32byte (uint32 0xFFFFFFFF) input
        ~~~result

    // CRC32 from ASCII string
    let crc32OfAscii (inputAscii : string) =
        let bytes = System.Text.Encoding.ASCII.GetBytes(inputAscii)
        crc32 bytes

    // Test
    let testString = "The quick brown fox jumps over the lazy dog"
    printfn "ASCII Input: %s" testString
    let result = crc32OfAscii testString
    printfn "CRC32: 0x%x" result
