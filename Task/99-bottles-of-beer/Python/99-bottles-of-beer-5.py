"""
Excercise of style. An overkill for the task :-D

1. OOP, with abstract class and implementation with much common magic methods
2. you can customize:
    a. the initial number
    b. the name of the item and its plural
    c. the string to display when there's no more items
    d. the normal action
    e. the final action
    f. the template used, for foreign languages
3. strofas of the song are created with multiprocessing
4. when you launch it as a script, you can specify an optional parameter for
   the number of initial items
"""

from string import Template
from abc import ABC, abstractmethod
from multiprocessing.pool import Pool as ProcPool
from functools import partial
import sys

class Song(ABC):
    @abstractmethod
    def sing(self):
        """
        it must return the song as a text-like object
        """

        pass

class MuchItemsSomewhere(Song):
    eq_attrs = (
        "initial_number",
        "zero_items",
        "action1",
        "action2",
        "item",
        "items",
        "strofa_tpl"
    )

    hash_attrs = eq_attrs
    repr_attrs = eq_attrs

    __slots__ = eq_attrs + ("_repr", "_hash")

    def __init__(
        self,
        items = "bottles of beer",
        item = "bottle of beer",
        where = "on the wall",
        initial_number = None,
        zero_items = "No more",
        action1 = "Take one down, pass it around",
        action2 = "Go to the store, buy some more",
        template = None,
    ):
        initial_number_true = 99 if initial_number is None else initial_number

        try:
            is_initial_number_int = (initial_number_true % 1) == 0
        except Exception:
            is_initial_number_int = False

        if not is_initial_number_int:
            raise ValueError("`initial_number` parameter must be None or a int-like object")

        if initial_number_true < 0:
            raise ValueError("`initial_number` parameter must be >=0")


        true_tpl = template or """\
$i $items1 $where
$i $items1
$action
$j $items2 $where"""

        strofa_tpl_tmp = Template(true_tpl)
        strofa_tpl = Template(strofa_tpl_tmp.safe_substitute(where=where))

        self.zero_items = zero_items
        self.action1 = action1
        self.action2 = action2
        self.initial_number = initial_number_true
        self.item = item
        self.items = items
        self.strofa_tpl = strofa_tpl
        self._hash = None
        self._repr = None

    def strofa(self, number):
        zero_items = self.zero_items
        item = self.item
        items = self.items

        if number == 0:
            i = zero_items
            action = self.action2
            j = self.initial_number
        else:
            i = number
            action = self.action1
            j = i - 1

        if i == 1:
            items1 = item
            j = zero_items
        else:
            items1 = items

        if j == 1:
            items2 = item
        else:
            items2 = items

        return self.strofa_tpl.substitute(
            i = i,
            j = j,
            action = action,
            items1 = items1,
            items2 = items2
        )

    def sing(self):
        with ProcPool() as proc_pool:
            strofa = self.strofa
            initial_number = self.initial_number
            args = range(initial_number, -1, -1)
            return "\n\n".join(proc_pool.map(strofa, args))

    def __copy__(self, *args, **kwargs):
        return self

    def __deepcopy__(self, *args, **kwargs):
        return self

    def __eq__(self, other, *args, **kwargs):
        if self is other:
            return True

        getmyattr = partial(getattr, self)
        getotherattr = partial(getattr, other)
        eq_attrs = self.eq_attrs

        for attr in eq_attrs:
            val = getmyattr(attr)

            try:
                val2 = getotherattr(attr)
            except Exception:
                return False

            if attr == "strofa_tpl":
                val_true = val.safe_substitute()
                val2_true = val.safe_substitute()
            else:
                val_true = val
                val2_true = val

            if val_true != val2_true:
                return False

        return True

    def __hash__(self, *args, **kwargs):
        _hash = self._hash

        if _hash is None:
            getmyattr = partial(getattr, self)
            attrs = self.hash_attrs
            hash_true = self._hash = hash(tuple(map(getmyattr, attrs)))
        else:
            hash_true = _hash

        return hash_true

    def __repr__(self, *args, **kwargs):
        _repr = self._repr

        if _repr is None:
            repr_attrs = self.repr_attrs
            getmyattr = partial(getattr, self)

            attrs = []

            for attr in repr_attrs:
                val = getmyattr(attr)

                if attr == "strofa_tpl":
                    val_true = val.safe_substitute()
                else:
                    val_true = val

                attrs.append(f"{attr}={repr(val_true)}")

            repr_true = self._repr = f"{self.__class__.__name__}({', '.join(attrs)})"
        else:
            repr_true = _repr

        return repr_true

def muchBeersOnTheWall(num):
    song = MuchItemsSomewhere(initial_number=num)

    return song.sing()

def balladOfProgrammer(num):
    """
    Prints
    "99 Subtle Bugs in Production"
    or
    "The Ballad of Programmer"
    """

    song = MuchItemsSomewhere(
        initial_number = num,
        items = "subtle bugs",
        item = "subtle bug",
        where = "in Production",
        action1 = "Debug and catch, commit a patch",
        action2 = "Release the fixes, wait for some tickets",
        zero_items = "Zarro",
    )

    return song.sing()

def main(num):
    print(f"### {num} Bottles of Beers on the Wall ###")
    print()
    print(muchBeersOnTheWall(num))
    print()
    print()
    print('### "The Ballad of Programmer", by Marco Sulla')
    print()
    print(balladOfProgrammer(num))

if __name__ == "__main__":
    # Ok, argparse is **really** too much
    argv = sys.argv

    if len(argv) == 1:
        num = None
    elif len(argv) == 2:
        try:
            num = int(argv[1])
        except Exception:
            raise ValueError(
                f"{__file__} parameter must be an integer, or can be omitted"
            )
    else:
        raise RuntimeError(f"{__file__} takes one parameter at max")

    main(num)

__all__ = (Song.__name__, MuchItemsSomewhere.__name__, muchBeersOnTheWall.__name__, balladOfProgrammer.__name__)
