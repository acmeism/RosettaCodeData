open System.Windows.Forms
open System.Runtime.InteropServices

#nowarn "9"
[<Struct; StructLayout(LayoutKind.Sequential)>]
type POINT =
    new (x, y) = { X = x; Y = y }
    val X : int
    val Y : int

[<DllImport("user32.dll")>]
extern nativeint GetForegroundWindow();
[<DllImport("user32.dll", CharSet=CharSet.Auto, SetLastError=true, ExactSpelling=true)>]
extern int ScreenToClient(nativeint hWnd, POINT &pt);

let GetMousePosition() =
    let hwnd = GetForegroundWindow()
    let pt = Cursor.Position
    let mutable ptFs = new POINT(pt.X, pt.Y)
    ScreenToClient(hwnd, &ptFs) |> ignore
    ptFs
