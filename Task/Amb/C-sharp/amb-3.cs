using System;
using System.Collections.Generic;

namespace Amb {
    public interface IValue<T> {
        T Value { get; }
        string ToString();
    }

    public sealed class Amb {
        public IValue<T> Choose<T>(params T[] choices) {
            var array = new ChoiceArray<T> { Values = choices };
            _choices.Add(array);
            return array;
        }

        public void Require(Func<bool> predicate) =>
            _constraints.Add(new Constraint { Predicate = predicate, AppliesForItems = _choices.Count });

        public bool Disambiguate() => Disambiguate(0, 0);

        interface IChoices {
            int Length { get; }
            int Index { get; set; }
        }

        interface IConstraint {
            int AppliesForItems { get; }
            bool Invoke();
        }

        readonly List<IChoices> _choices = new();
        readonly List<IConstraint> _constraints = new();

        bool Disambiguate(int choicesTracked, int constraintIdx) {
            while (constraintIdx < _constraints.Count && _constraints[constraintIdx].AppliesForItems <= choicesTracked) {
                if (!_constraints[constraintIdx].Invoke())
                    return false;
                constraintIdx++;
            }

            if (choicesTracked == _choices.Count)
                return true;

            for (var i = 0; i < _choices[choicesTracked].Length; i++) {
                _choices[choicesTracked].Index = i;
                if (Disambiguate(choicesTracked + 1, constraintIdx))
                    return true;
            }
            return false;
        }

        class Constraint : IConstraint {
            internal Func<bool> Predicate;

            public int AppliesForItems { get; set; }

            public bool Invoke() => Predicate?.Invoke() ?? default;
        }

        class ChoiceArray<T> : IChoices, IValue<T> {
            internal T[] Values;

            public int Index { get; set; }

            public T Value => Values[Index];

            public int Length => Values.Length;

            public override string ToString() => Value.ToString();
        }
    }
}
