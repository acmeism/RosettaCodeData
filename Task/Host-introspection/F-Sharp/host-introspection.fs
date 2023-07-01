open System
open System.Runtime.InteropServices
open System.Diagnostics

[<DllImport("kernel32.dll", SetLastError = true, CallingConvention = CallingConvention.Winapi)>]
extern bool IsWow64Process(nativeint hProcess, bool &wow64Process);

let answerHostInfo =
    let Is64Bit() =
        let mutable f64Bit = false;
        IsWow64Process(Process.GetCurrentProcess().Handle, &f64Bit) |> ignore
        f64Bit
    let IsLittleEndian() = BitConverter.IsLittleEndian
    (IsLittleEndian(), Is64Bit())
