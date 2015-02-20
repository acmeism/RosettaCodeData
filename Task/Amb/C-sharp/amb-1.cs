using System;
using System.Collections.Generic;

public class Amb : IDisposable
{
    List<IValueSet> streams = new List<IValueSet>();
    List<IAssertOrAction> assertsOrActions = new List<IAssertOrAction>();
    volatile bool stopped = false;

    public IAmbValue<T> DefineValues<T>(params T[] values)
    {
        return DefineValueSet(values);
    }

    public IAmbValue<T> DefineValueSet<T>(IEnumerable<T> values)
    {
        ValueSet<T> stream = new ValueSet<T>();
        stream.Enumerable = values;
        streams.Add(stream);
        return stream;
    }

    public Amb Assert(Func<bool> function)
    {
        assertsOrActions.Add(new AmbAssert()
        {
            Level = streams.Count,
            IsValidFunction = function
        });
        return this;
    }

    public Amb Perform(Action action)
    {
        assertsOrActions.Add(new AmbAction()
        {
            Level = streams.Count,
            Action = action
        });
        return this;
    }

    public void Stop()
    {
        stopped = true;
    }

    public void Dispose()
    {
        RunLevel(0, 0);
        if (!stopped)
        {
            throw new AmbException();
        }
    }

    void RunLevel(int level, int actionIndex)
    {
        while (actionIndex < assertsOrActions.Count && assertsOrActions[actionIndex].Level <= level)
        {
            if (!assertsOrActions[actionIndex].Invoke() || stopped)
                return;
            actionIndex++;
        }
        if (level < streams.Count)
        {
            using (IValueSetIterator iterator = streams[level].CreateIterator())
            {
                while (iterator.MoveNext())
                {
                    RunLevel(level + 1, actionIndex);
                }
            }
        }
    }

    interface IValueSet
    {
        IValueSetIterator CreateIterator();
    }

    interface IValueSetIterator : IDisposable
    {
        bool MoveNext();
    }

    interface IAssertOrAction
    {
        int Level { get; }
        bool Invoke();
    }

    class AmbAssert : IAssertOrAction
    {
        internal int Level;
        internal Func<bool> IsValidFunction;

        int IAssertOrAction.Level { get { return Level; } }

        bool IAssertOrAction.Invoke()
        {
            return IsValidFunction();
        }
    }

    class AmbAction : IAssertOrAction
    {
        internal int Level;
        internal Action Action;

        int IAssertOrAction.Level { get { return Level; } }

        bool IAssertOrAction.Invoke()
        {
            Action(); return true;
        }
    }

    class ValueSet<T> : IValueSet, IAmbValue<T>, IValueSetIterator
    {
        internal IEnumerable<T> Enumerable;
        private IEnumerator<T> enumerator;

        public T Value { get { return enumerator.Current; } }

        public IValueSetIterator CreateIterator()
        {
            enumerator = Enumerable.GetEnumerator();
            return this;
        }

        public bool MoveNext()
        {
            return enumerator.MoveNext();
        }

        public void Dispose()
        {
            enumerator.Dispose();
        }
    }
}

public interface IAmbValue<T>
{
    T Value { get; }
}

public class AmbException : Exception
{
    public AmbException() : base("AMB is angry") { }
}
