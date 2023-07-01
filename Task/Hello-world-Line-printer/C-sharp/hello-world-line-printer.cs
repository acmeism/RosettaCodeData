[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
public class DOCINFOA
{
    [MarshalAs(UnmanagedType.LPStr)]
    public string pDocName;
    [MarshalAs(UnmanagedType.LPStr)]
    public string pOutputFile;
    [MarshalAs(UnmanagedType.LPStr)]
    public string pDataType;
}

[DllImport("winspool.Drv", EntryPoint = "OpenPrinterA", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool OpenPrinter([MarshalAs(UnmanagedType.LPStr)] string szPrinter, out IntPtr hPrinter, IntPtr pd);

[DllImport("winspool.Drv", EntryPoint = "StartDocPrinterA", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool StartDocPrinter(IntPtr hPrinter, int level, [In, MarshalAs(UnmanagedType.LPStruct)] DOCINFOA di);

[DllImport("winspool.Drv", EntryPoint = "StartPagePrinter", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool StartPagePrinter(IntPtr hPrinter);

[DllImport("winspool.Drv", EntryPoint = "EndPagePrinter", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool EndPagePrinter(IntPtr hPrinter);

[DllImport("winspool.Drv", EntryPoint = "EndDocPrinter", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool EndDocPrinter(IntPtr hPrinter);

[DllImport("winspool.Drv", EntryPoint = "ClosePrinter", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool ClosePrinter(IntPtr hPrinter);

[DllImport("winspool.Drv", EntryPoint = "WritePrinter", CharSet = CharSet.Ansi, ExactSpelling = true)]
public static extern bool WritePrinter(IntPtr hPrinter, IntPtr pBytes, Int32 dwCount, out Int32 dwWritten);

public void HelloWorld()
{
    IntPtr hPrinter;
    bool openSuccessful = OpenPrinter("My Printer", out hPrinter, IntPtr.Zero);
    if (openSuccessful)
    {
        DOCINFOA docInfo = new DOCINFOA();
        docInfo.pDocName = "Hello World Example";
        docInfo.pOutputFile = null;
        docInfo.pDataType = "RAW";

        if (StartDocPrinter(hPrinter, 1, docInfo))
        {
            StartPagePrinter(hPrinter);

            const string helloWorld = "Hello World!";
            IntPtr buf = Marshal.StringToCoTaskMemAnsi(helloWorld);

            int bytesWritten;
            WritePrinter(hPrinter, buf, helloWorld.Length, out bytesWritten);

            Marshal.FreeCoTaskMem(buf);
        }
        if (EndPagePrinter(hPrinter))
            if (EndDocPrinter(hPrinter))
                ClosePrinter(hPrinter);
    }
}
