using System;
using System.Runtime.InteropServices;

public unsafe class Program
{
    public static unsafe void HeapMemory()
    {
        const int HEAP_ZERO_MEMORY = 0x00000008;
        const int size = 1000;
        int ph = GetProcessHeap();
        void* pointer = HeapAlloc(ph, HEAP_ZERO_MEMORY, size);
        if (pointer == null)
            throw new OutOfMemoryException();
        Console.WriteLine(HeapSize(ph, 0, pointer));
        HeapFree(ph, 0, pointer);
    }

    public static unsafe void StackMemory()
    {
        byte* buffer = stackalloc byte[1000];
        // buffer is automatically discarded when the method returns
    }
    public static void Main(string[] args)
    {
        HeapMemory();
        StackMemory();
    }
    [DllImport("kernel32")]
    static extern void* HeapAlloc(int hHeap, int flags, int size);
    [DllImport("kernel32")]
    static extern bool HeapFree(int hHeap, int flags, void* block);
    [DllImport("kernel32")]
    static extern int GetProcessHeap();
    [DllImport("kernel32")]
    static extern int HeapSize(int hHeap, int flags, void* block);

}
