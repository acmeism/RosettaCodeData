using System;
using System.Collections.Generic;

namespace Amb
{
    public interface IValue<T>
    {
        T Value { get; }
        string ToString();
    }

    public sealed class Amb
    {
        public IValue<T> Choose<T>(params T[] choices)
        {
            var array = new ChoiceArray<T> { Values = choices };
            _itemsChoices.Add(array);
            return array;
        }

        public void Require(Func<bool> predicate) =>
            _constraints.Add(new Constraint { Predicate = predicate, AppliesForItems = _itemsChoices.Count });

        public bool RequireFinal(Func<bool> predicate)
        {
            Require(predicate);
            return Disambiguate();
        }

        public bool Disambiguate()
        {
            try
            {
                Disambiguate(0, 0);
                return false;
            }
            catch (Exception ex) when (ex.Message == "Success")
            {
                return true;
            }
        }

        interface IChoices
        {
            int Length { get; }
            int Index { get; set; }
        }

        interface IConstraint
        {
            int AppliesForItems { get; }
            bool Invoke();
        }

        List<IChoices> _itemsChoices = new List<IChoices>();
        List<IConstraint> _constraints = new List<IConstraint>();

        void Disambiguate(int itemsTracked, int constraintIndex)
        {
            while (constraintIndex < _constraints.Count && _constraints[constraintIndex].AppliesForItems <= itemsTracked)
            {
                if (!_constraints[constraintIndex].Invoke())
                    return;
                constraintIndex++;
            }

            if (itemsTracked == _itemsChoices.Count)
            {
                throw new Exception("Success");
            }

            for (var i = 0; i < _itemsChoices[itemsTracked].Length; i++)
            {
                 _itemsChoices[itemsTracked].Index = i;
                 Disambiguate(itemsTracked + 1, constraintIndex);
            }
        }

        class Constraint : IConstraint
        {
            internal int AppliesForItems;
            int IConstraint.AppliesForItems => AppliesForItems;

            internal Func<bool> Predicate;
            public bool Invoke() => Predicate?.Invoke() ?? default;
        }

        class ChoiceArray<T> : IChoices, IValue<T>
        {
            internal T[] Values;

            public int Index { get; set; }

            public T Value { get { return Values[Index]; } }

            public int Length => Values.Length;

            public override string ToString() => Value.ToString();
        }
    }
}
