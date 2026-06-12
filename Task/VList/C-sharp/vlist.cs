using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public sealed class VListTask
{
    public static void Main(string[] args)
    {
        VList<int> vList = new VList<int>();
        Console.WriteLine("Before adding any elements, the VList is empty: " + vList);
        vList.ShowStructure();

        for (int i = 6; i >= 1; i--)
        {
            vList = vList.Cons(i);
        }
        Console.WriteLine("Demonstrating cons method, 6 elements added: " + vList);
        vList.ShowStructure();

        vList = vList.Cdr();
        Console.WriteLine("Demonstrating cdr method, 1 element removed: " + vList);
        vList.ShowStructure();

        Console.WriteLine("Demonstrating size property, size = " + vList.Size() + "\n");
        Console.WriteLine("Demonstrating element access, v[3] = " + vList.Get(3) + "\n");

        vList = vList.Cdr().Cdr();
        Console.WriteLine("Demonstrating cdr method again, 2 more elements removed: " + vList);
        vList.ShowStructure();
    }
}

public sealed class VList<T>
{
    private VSegment<T> _base;
    private int _offset;

    public VList()
    {
        _base = new VSegment<T>();
        _base.Elements = new List<T>();
        _offset = 0;
    }

    // Add an element to the beginning of this VList
    public VList<T> Cons(T element)
    {
        if (_base.Elements.Count == 0)
        {
            _base.Elements.Add(element);
            return this;
        }

        if (_offset == 0)
        {
            _offset = _base.Elements.Count * 2 - 1;
            VSegment<T> segment = new VSegment<T>();
            segment.Next = _base;
            segment.Elements = Enumerable.Repeat(default(T), _offset).ToList();
            segment.Elements.Add(element);
            _base = segment;
            return this;
        }

        _offset -= 1;
        _base.Elements[_offset] = element;
        return this;
    }

    // Return a new VList beginning at the second element this VList
    public VList<T> Cdr()
    {
        if (_base.Elements.Count == 0)
        {
            throw new InvalidOperationException("cdr invoked on an empty VList");
        }

        _offset += 1;
        if (_offset < _base.Elements.Count)
        {
            return this;
        }

        _offset = 0;
        _base = _base.Next;
        return this;
    }

    // Return the element located at the given index
    public T Get(int key)
    {
        if (key >= 0)
        {
            int index = key + _offset;
            VSegment<T> segment = _base;
            while (segment != null)
            {
                if (index < segment.Elements.Count)
                {
                    return segment.Elements[index];
                }

                index -= segment.Elements.Count;
                segment = segment.Next;
            }
        }

        throw new ArgumentOutOfRangeException(nameof(key), "Index out of range: " + key);
    }

    // Return the size of this VList
    public int Size()
    {
        return _base.Elements.Count == 0 ? 0 : _base.Elements.Count * 2 - _offset - 1;
    }

    public override string ToString()
    {
        if (_base.Elements.Count == 0)
        {
            return "[]";
        }

        StringBuilder result = new StringBuilder("[" + _base.Elements[_offset]);
        VSegment<T> segment = _base;
        List<T> elementsSublist = _base.Elements.GetRange(_offset + 1, _base.Elements.Count - _offset - 1);

        while (true)
        {
            foreach (T element in elementsSublist)
            {
                result.Append(" " + element);
            }
            segment = segment.Next;
            if (segment == null)
            {
                break;
            }
            elementsSublist = segment.Elements;
        }
        result.Append("]");
        return result.ToString();
    }

    public void ShowStructure()
    {
        Console.WriteLine("Offset: " + _offset);
        VSegment<T> segment = _base;
        while (segment != null)
        {
            Console.WriteLine("[" + string.Join(", ", segment.Elements) + "]");
            segment = segment.Next;
        }
        Console.WriteLine();
    }

    private sealed class VSegment<TElement>
    {
        public VSegment<TElement> Next { get; set; }
        public List<TElement> Elements { get; set; }
    }
}
