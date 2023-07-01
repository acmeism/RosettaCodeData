# Module: calculus.py

import enum

class entry_not_found(Exception):
   """Raised when an entry is not found in a collection"""
   pass

class entry_already_exists(Exception):
   """Raised when an entry already exists in a collection"""
   pass

class state(enum.Enum):
   header = 0
   left_high = 1
   right_high = 2
   balanced = 3

class direction(enum.Enum):
   from_left = 0
   from_right = 1

from abc import ABC, abstractmethod

class comparer(ABC):

    @abstractmethod
    def compare(self,t):
        pass

class node(comparer):

    def __init__(self):
        self.parent = None
        self.left = self
        self.right = self
        self.balance = state.header

    def compare(self,t):
        if self.key < t:
             return -1
        elif t < self.key:
             return 1
        else:
             return 0

    def is_header(self):
        return self.balance == state.header

    def length(self):
        if self != None:
           if self.left != None:
              left = self.left.length()
           else:
              left = 0
           if self.right != None:
              right = self.right.length()
           else:
              right = 0

           return left + right + 1
        else:
           return 0

    def rotate_left(self):
         _parent = self.parent
         x = self.right
         self.parent = x
         x.parent = _parent
         if x.left is not None:
             x.left.parent = self
         self.right = x.left
         x.left = self
         return x


    def rotate_right(self):
        _parent = self.parent
        x = self.left
        self.parent = x
        x.parent = _parent;
        if x.right is not None:
            x.right.parent = self
        self.left = x.right
        x.right = self
        return x

    def balance_left(self):

       _left = self.left

       if _left is None:
          return self;

       if _left.balance == state.left_high:
                self.balance = state.balanced
                _left.balance = state.balanced
                self = self.rotate_right()
       elif _left.balance == state.right_high:
                subright = _left.right
                if subright.balance == state.balanced:
                        self.balance = state.balanced
                        _left.balance = state.balanced
                elif subright.balance == state.right_high:
                        self.balance = state.balanced
                        _left.balance = state.left_high
                elif subright.balance == left_high:
                        root.balance = state.right_high
                        _left.balance = state.balanced
                subright.balance = state.balanced
                _left = _left.rotate_left()
                self.left = _left
                self = self.rotate_right()
       elif _left.balance == state.balanced:
               self.balance = state.left_high
               _left.balance = state.right_high
               self = self.rotate_right()
       return self;

    def balance_right(self):

       _right = self.right

       if _right is None:
          return self;

       if _right.balance == state.right_high:
                self.balance = state.balanced
                _right.balance = state.balanced
                self = self.rotate_left()
       elif _right.balance == state.left_high:
                subleft = _right.left;
                if subleft.balance == state.balanced:
                        self.balance = state.balanced
                        _right.balance = state.balanced
                elif subleft.balance == state.left_high:
                        self.balance = state.balanced
                        _right.balance = state.right_high
                elif subleft.balance == state.right_high:
                        self.balance = state.left_high
                        _right.balance = state.balanced
                subleft.balance = state.balanced
                _right = _right.rotate_right()
                self.right = _right
                self = self.rotate_left()
       elif _right.balance == state.balanced:
                self.balance = state.right_high
                _right.balance = state.left_high
                self = self.rotate_left()
       return self


    def balance_tree(self, direct):
        taller = True
        while taller:
            _parent = self.parent;
            if _parent.left == self:
                next_from =  direction.from_left
            else:
                next_from = direction.from_right;

            if direct == direction.from_left:
                if self.balance == state.left_high:
                        if _parent.is_header():
                            _parent.parent = _parent.parent.balance_left()
                        elif _parent.left == self:
                            _parent.left = _parent.left.balance_left()
                        else:
                            _parent.right = _parent.right.balance_left()
                        taller = False

                elif self.balance == state.balanced:
                        self.balance = state.left_high
                        taller = True

                elif self.balance == state.right_high:
                        self.balance = state.balanced
                        taller = False
            else:
              if self.balance == state.left_high:
                        self.balance = state.balanced
                        taller = False

              elif self.balance ==  state.balanced:
                        self.balance = state.right_high
                        taller = True

              elif self.balance ==  state.right_high:
                        if _parent.is_header():
                            _parent.parent = _parent.parent.balance_right()
                        elif _parent.left == self:
                            _parent.left = _parent.left.balance_right()
                        else:
                            _parent.right = _parent.right.balance_right()
                        taller = False

            if taller:
                if _parent.is_header():
                    taller = False
                else:
                    self = _parent
                    direct = next_from

    def balance_tree_remove(self, _from):

        if self.is_header():
            return;

        shorter = True;

        while shorter:
            _parent = self.parent;
            if _parent.left == self:
                next_from = direction.from_left
            else:
                next_from = direction.from_right

            if _from == direction.from_left:
                if self.balance == state.left_high:
                        shorter = True

                elif self.balance == state.balanced:
                        self.balance = state.right_high;
                        shorter = False

                elif self.balance == state.right_high:
                        if self.right is not None:
                            if self.right.balance == state.balanced:
                                shorter = False
                            else:
                                shorter = True
                        else:
                            shorter = False;

                        if _parent.is_header():
                            _parent.parent = _parent.parent.balance_right()
                        elif _parent.left == self:
                            _parent.left = _parent.left.balance_right();
                        else:
                            _parent.right = _parent.right.balance_right()

            else:
                if self.balance == state.right_high:
                        self.balance = state.balanced
                        shorter = True

                elif self.balance == state.balanced:
                        self.balance = state.left_high
                        shorter = False

                elif self.balance == state.left_high:

                        if self.left is not None:
                            if self.left.balance == state.balanced:
                                shorter = False
                            else:
                                shorter = True
                        else:
                           short = False;

                        if _parent.is_header():
                            _parent.parent = _parent.parent.balance_left();
                        elif _parent.left == self:
                            _parent.left = _parent.left.balance_left();
                        else:
                            _parent.right = _parent.right.balance_left();

            if shorter:
               if _parent.is_header():
                    shorter = False
               else:
                    _from = next_from
                    self = _parent

    def previous(self):
        if self.is_header():
            return self.right

        if self.left is not None:
            y = self.left
            while y.right is not None:
                y = y.right
            return y

        else:
            y = self.parent;
            if y.is_header():
                return y

            x = self
            while x == y.left:
                x = y
                y = y.parent

            return y

    def next(self):
        if self.is_header():
            return self.left

        if self.right is not None:
            y = self.right
            while y.left is not None:
                y = y.left
            return y;

        else:
            y = self.parent
            if y.is_header():
                return y

            x = self;
            while x == y.right:
                x = y
                y = y.parent;

            return y

    def swap_nodes(a, b):

        if b == a.left:
            if b.left is not None:
                b.left.parent = a

            if b.right is not None:
                b.right.parent = a

            if a.right is not None:
                a.right.parent = b

            if not a.parent.is_header():
                if a.parent.left == a:
                    a.parent.left = b
                else:
                    a.parent.right = b;
            else:
                a.parent.parent = b

            b.parent = a.parent
            a.parent = b

            a.left = b.left
            b.left = a

            temp = a.right
            a.right = b.right
            b.right = temp
        elif b == a.right:
            if b.right is not None:
                b.right.parent = a

            if b.left is not None:
               b.left.parent = a

            if a.left is not None:
               a.left.parent = b

            if not a.parent.is_header():
                if a.parent.left == a:
                    a.parent.left = b
                else:
                    a.parent.right = b
            else:
               a.parent.parent = b

            b.parent = a.parent
            a.parent = b

            a.right = b.right
            b.right = a

            temp = a.left
            a.left = b.left
            b.left = temp
        elif a == b.left:
            if a.left is not None:
                a.left.parent = b

            if a.right is not None:
                a.right.parent = b

            if b.right is not None:
                b.right.parent = a

            if not parent.is_header():
                if b.parent.left == b:
                    b.parent.left = a
                else:
                    b.parent.right = a
            else:
                b.parent.parent = a

            a.parent = b.parent
            b.parent = a

            b.left = a.left
            a.left = b

            temp = a.right
            a.right = b.right
            b.right = temp
        elif a == b.right:
            if a.right is not None:
                a.right.parent = b
            if a.left is not None:
               a.left.parent = b

            if b.left is not None:
               b.left.parent = a

            if not b.parent.is_header():
                if b.parent.left == b:
                    b.parent.left = a
                else:
                    b.parent.right = a
            else:
                b.parent.parent = a

            a.parent = b.parent
            b.parent = a

            b.right = a.right
            a.right = b

            temp = a.left
            a.left = b.left
            b.left = temp
        else:
            if a.parent == b.parent:
                temp = a.parent.left
                a.parent.left = a.parent.right
                a.parent.right = temp
            else:
                if not a.parent.is_header():
                    if a.parent.left == a:
                        a.parent.left = b
                    else:
                        a.parent.right = b
                else:
                    a.parent.parent = b

                if not b.parent.is_header():
                    if b.parent.left == b:
                        b.parent.left = a
                    else:
                        b.parent.right = a
                else:
                    b.parent.parent = a

            if b.left is not None:
                b.left.parent = a

            if b.right is not None:
                b.right.parent = a

            if a.left is not None:
                a.left.parent = b

            if a.right is not None:
                a.right.parent = b

            temp1 = a.left
            a.left = b.left
            b.left = temp1

            temp2 = a.right
            a.right = b.right
            b.right = temp2

            temp3 = a.parent
            a.parent = b.parent
            b.parent = temp3

        balance = a.balance
        a.balance = b.balance
        b.balance = balance

class parent_node(node):

    def __init__(self, parent):
        self.parent = parent
        self.left = None
        self.right = None
        self.balance = state.balanced

class set_node(node):

    def __init__(self, parent, key):
        self.parent = parent
        self.left = None
        self.right = None
        self.balance = state.balanced
        self.key = key

class ordered_set:

    def __init__(self):
        self.header = node()

    def __iter__(self):
        self.node = self.header
        return self

    def __next__(self):
        self.node = self.node.next()
        if self.node.is_header():
            raise StopIteration
        return self.node.key

    def __delitem__(self, key):
          self.remove(key)

    def __lt__(self, other):
        first1 = self.header.left
        last1 = self.header
        first2 = other.header.left
        last2 = other.header

        while (first1 != last1) and (first2 != last2):
           l =  first1.key < first2.key
           if not l:
              first1 = first1.next();
              first2 = first2.next();
           else:
              return True;

        a = self.__len__()
        b = other.__len__()
        return a < b

    def __hash__(self):
        h = 0
        for i in self:
            h = h + i.__hash__()
        return h

    def __eq__(self, other):
       if self < other:
          return False
       if other < self:
          return False
       return True

    def __ne__(self, other):
       if self < other:
          return True
       if other < self:
          return True
       return False

    def __len__(self):
        return self.header.parent.length()

    def __getitem__(self, key):
          return self.contains(key)

    def __str__(self):
       l = self.header.right
       s = "{"
       i = self.header.left
       h = self.header
       while i != h:
           s = s + i.key.__str__()
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s

    def __or__(self, other):
       r = ordered_set()

       first1 = self.header.left
       last1 = self.header
       first2 = other.header.left
       last2 = other.header

       while first1 != last1 and first2 != last2:
          les = first1.key < first2.key
          graater = first2.key < first1.key

          if les:
             r.add(first1.key)
             first1 = first1.next()
          elif graater:
             r.add(first2.key)
             first2 = first2.next()
          else:
             r.add(first1.key)
             first1 = first1.next()
             first2 = first2.next()

       while first1 != last1:
          r.add(first1.key)
          first1 = first1.next()

       while first2 != last2:
          r.add(first2.key)
          first2 = first2.next()

       return r

    def __and__(self, other):
       r = ordered_set()

       first1 = self.header.left
       last1 = self.header
       first2 = other.header.left
       last2 = other.header

       while first1 != last1 and first2 != last2:
          les = first1.key < first2.key
          graater = first2.key < first1.key

          if les:
             first1 = first1.next()
          elif graater:
             first2 = first2.next()
          else:
             r.add(first1.key)
             first1 = first1.next()
             first2 = first2.next()

       return r

    def __xor__(self, other):
       r = ordered_set()

       first1 = self.header.left
       last1 = self.header
       first2 = other.header.left
       last2 = other.header

       while first1 != last1 and first2 != last2:
          les = first1.key < first2.key
          graater = first2.key < first1.key

          if les:
             r.add(first1.key)
             first1 = first1.next()
          elif graater:
             r.add(first2.key)
             first2 = first2.next()
          else:
             first1 = first1.next()
             first2 = first2.next()

       while first1 != last1:
          r.add(first1.key)
          first1 = first1.next()

       while first2 != last2:
          r.add(first2.key)
          first2 = first2.next()

       return r


    def __sub__(self, other):
       r = ordered_set()

       first1 = self.header.left
       last1 = self.header
       first2 = other.header.left
       last2 = other.header

       while first1 != last1 and first2 != last2:
          les = first1.key < first2.key
          graater = first2.key < first1.key

          if les:
             r.add(first1.key)
             first1 = first1.next()
          elif graater:
             r.add(first2.key)
             first2 = first2.next()
          else:
             first1 = first1.next()
             first2 = first2.next()

       while first1 != last1:
          r.add(first1.key)
          first1 = first1.next()

       return r

    def __lshift__(self, data):
       self.add(data)
       return self

    def __rshift__(self, data):
       self.remove(data)
       return self

    def is_subset(self, other):
       first1 = self.header.left
       last1 = self.header
       first2 = other.header.left
       last2 = other.header

       is_subet = True

       while first1 != last1 and first2 != last2:
          if first1.key < first2.key:
              is_subset = False
              break
          elif first2.key < first1.key:
             first2 = first2.next()
          else:
             first1 = first1.next()
             first2 = first2.next()

          if is_subet:
             if first1 != last1:
                is_subet = False

       return is_subet

    def is_superset(self,other):
       return other.is_subset(self)

    def add(self, data):
            if self.header.parent is None:
                self.header.parent = set_node(self.header,data)
                self.header.left = self.header.parent
                self.header.right = self.header.parent
            else:

                root = self.header.parent

                while True:
                    c = root.compare(data)
                    if c >= 0:
                        if root.left is not None:
                            root = root.left
                        else:
                            new_node = set_node(root,data)
                            root.left = new_node

                            if self.header.left == root:
                                 self.header.left = new_node
                            root.balance_tree(direction.from_left)
                            return

                    else:
                        if root.right is not None:
                            root = root.right
                        else:
                            new_node = set_node(root, data)
                            root.right = new_node
                            if self.header.right == root:
                                  self.header.right = new_node
                            root.balance_tree(direction.from_right)
                            return

    def remove(self,data):
        root = self.header.parent;

        while True:
            if root is None:
                raise entry_not_found("Entry not found in collection")

            c  = root.compare(data)

            if c < 0:
               root = root.left;

            elif c > 0:
               root = root.right;

            else:

                 if root.left is not None:
                     if root.right is not None:
                         replace = root.left
                         while replace.right is not None:
                             replace = replace.right
                         root.swap_nodes(replace)

                 _parent = root.parent

                 if _parent.left == root:
                     _from = direction.from_left
                 else:
                     _from = direction.from_right

                 if self.header.left == root:

                     n = root.next();

                     if n.is_header():
                         self.header.left = self.header
                         self.header.right = self.header
                     else:
                        self.header.left = n
                 elif self.header.right == root:

                     p = root.previous();

                     if p.is_header():
                          self.header.left = self.header
                          self.header.right = self.header
                     else:
                          self.header.right = p

                 if root.left is None:
                     if _parent == self.header:
                         self.header.parent = root.right
                     elif _parent.left == root:
                         _parent.left = root.right
                     else:
                         _parent.right = root.right

                     if root.right is not None:
                          root.right.parent = _parent

                 else:
                     if _parent == self.header:
                          self.header.parent = root.left
                     elif _parent.left == root:
                         _parent.left = root.left
                     else:
                         _parent.right = root.left

                     if root.left is not None:
                         root.left.parent = _parent;


                 _parent.balance_tree_remove(_from)
                 return

    def contains(self,data):
        root = self.header.parent;

        while True:
            if root == None:
                return False

            c  = root.compare(data);

            if c > 0:
               root = root.left;

            elif c < 0:
               root = root.right;

            else:

                 return True


    def find(self,data):
        root = self.header.parent;

        while True:
            if root == None:
                raise entry_not_found("An entry is not found in a collection")

            c  = root.compare(data);

            if c > 0:
               root = root.left;

            elif c < 0:
               root = root.right;

            else:

                 return root.key;

class key_value(comparer):

    def __init__(self, key, value):
        self.key = key
        self.value = value

    def compare(self,kv):
        if self.key < kv.key:
             return -1
        elif kv.key < self.key:
             return 1
        else:
             return 0

    def __lt__(self, other):
        return self.key < other.key

    def __str__(self):
        return '(' + self.key.__str__() + ',' + self.value.__str__() + ')'

    def __eq__(self, other):
       return self.key == other.key

    def __hash__(self):
        return hash(self.key)


class dictionary:

    def __init__(self):
        self.set = ordered_set()
        return None

    def __lt__(self, other):
       if self.keys() < other.keys():
          return true

       if other.keys() < self.keys():
          return false

       first1 = self.set.header.left
       last1 = self.set.header
       first2 = other.set.header.left
       last2 = other.set.header

       while (first1 != last1) and (first2 != last2):
          l =  first1.key.value < first2.key.value
          if not l:
             first1 = first1.next();
             first2 = first2.next();
          else:
             return True;

       a = self.__len__()
       b = other.__len__()
       return a < b


    def add(self, key, value):
       try:
           self.set.remove(key_value(key,None))
       except entry_not_found:
            pass
       self.set.add(key_value(key,value))
       return

    def remove(self, key):
       self.set.remove(key_value(key,None))
       return

    def clear(self):
       self.set.header = node()

    def sort(self):

      sort_bag = bag()
      for e in self:
        sort_bag.add(e.value)
      keys_set = self.keys()
      self.clear()
      i = sort_bag.__iter__()
      i = sort_bag.__next__()
      try:
        for e in keys_set:
          self.add(e,i)
          i = sort_bag.__next__()
      except:
         return

    def keys(self):
         keys_set = ordered_set()
         for e in self:
             keys_set.add(e.key)
         return keys_set

    def __len__(self):
        return self.set.header.parent.length()

    def __str__(self):
       l = self.set.header.right;
       s = "{"
       i = self.set.header.left;
       h = self.set.header;
       while i != h:
           s = s + "("
           s = s + i.key.key.__str__()
           s = s + ","
           s = s + i.key.value.__str__()
           s = s + ")"
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s;

    def __iter__(self):

        self.set.node = self.set.header
        return self

    def __next__(self):
        self.set.node = self.set.node.next()
        if self.set.node.is_header():
            raise StopIteration
        return key_value(self.set.node.key.key,self.set.node.key.value)

    def __getitem__(self, key):
          kv = self.set.find(key_value(key,None))
          return kv.value

    def __setitem__(self, key, value):
          self.add(key,value)
          return

    def __delitem__(self, key):
          self.set.remove(key_value(key,None))


class array:

    def __init__(self):
        self.dictionary = dictionary()
        return None

    def __len__(self):
        return self.dictionary.__len__()

    def push(self, value):
       k = self.dictionary.set.header.right
       if k == self.dictionary.set.header:
           self.dictionary.add(0,value)
       else:
           self.dictionary.add(k.key.key+1,value)
       return

    def pop(self):
       if self.dictionary.set.header.parent != None:
          data = self.dictionary.set.header.right.key.value
          self.remove(self.dictionary.set.header.right.key.key)
          return data

    def add(self, key, value):
       try:
          self.dictionary.remove(key)
       except entry_not_found:
          pass
       self.dictionary.add(key,value)
       return

    def remove(self, key):
       self.dictionary.remove(key)
       return

    def sort(self):
       self.dictionary.sort()

    def clear(self):
      self.dictionary.header = node();


    def __iter__(self):
        self.dictionary.node = self.dictionary.set.header
        return self

    def __next__(self):
        self.dictionary.node = self.dictionary.node.next()
        if self.dictionary.node.is_header():
            raise StopIteration
        return self.dictionary.node.key.value

    def __getitem__(self, key):
          kv = self.dictionary.set.find(key_value(key,None))
          return kv.value

    def __setitem__(self, key, value):
          self.add(key,value)
          return

    def __delitem__(self, key):
          self.dictionary.remove(key)

    def __lshift__(self, data):
         self.push(data)
         return self

    def __lt__(self, other):
       return self.dictionary < other.dictionary

    def __str__(self):
       l = self.dictionary.set.header.right;
       s = "{"
       i = self.dictionary.set.header.left;
       h = self.dictionary.set.header;
       while i != h:
           s = s + i.key.value.__str__()
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s;


class bag:

    def __init__(self):
        self.header = node()

    def __iter__(self):
        self.node = self.header
        return self

    def __delitem__(self, key):
          self.remove(key)

    def __next__(self):
        self.node = self.node.next()
        if self.node.is_header():
            raise StopIteration
        return self.node.key

    def __str__(self):
       l = self.header.right;
       s = "("
       i = self.header.left;
       h = self.header;
       while i != h:
           s = s + i.key.__str__()
           if i != l:
               s = s + ","
           i = i.next()

       s = s + ")"
       return s;

    def __len__(self):
        return self.header.parent.length()

    def __lshift__(self, data):
       self.add(data)
       return self

    def add(self, data):
            if self.header.parent is None:
                self.header.parent = set_node(self.header,data)
                self.header.left = self.header.parent
                self.header.right = self.header.parent
            else:

                root = self.header.parent

                while True:
                    c = root.compare(data)
                    if c >= 0:
                        if root.left is not None:
                            root = root.left
                        else:
                            new_node = set_node(root,data)
                            root.left = new_node

                            if self.header.left == root:
                                 self.header.left = new_node

                            root.balance_tree(direction.from_left)
                            return

                    else:
                        if root.right is not None:
                            root = root.right
                        else:
                            new_node = set_node(root, data)
                            root.right = new_node

                            if self.header.right == root:
                                  self.header.right = new_node

                            root.balance_tree(direction.from_right)
                            return

    def remove_first(self,data):

        root = self.header.parent;

        while True:
            if root is None:
                return False;

            c  = root.compare(data);

            if c > 0:
               root = root.left;

            elif c < 0:
               root = root.right;

            else:

                 if root.left is not None:
                     if root.right is not None:
                         replace = root.left;
                         while replace.right is not None:
                             replace = replace.right;
                         root.swap_nodes(replace);

                 _parent = root.parent

                 if _parent.left == root:
                     _from = direction.from_left
                 else:
                     _from = direction.from_right

                 if self.header.left == root:

                     n = root.next();

                     if n.is_header():
                         self.header.left = self.header
                         self.header.right = self.header
                     else:
                        self.header.left = n;
                 elif self.header.right == root:

                     p = root.previous();

                     if p.is_header():
                          self.header.left = self.header
                          self.header.right = self.header
                     else:
                          self.header.right = p

                 if root.left is None:
                     if _parent == self.header:
                         self.header.parent = root.right
                     elif _parent.left == root:
                         _parent.left = root.right
                     else:
                         _parent.right = root.right

                     if root.right is not None:
                          root.right.parent = _parent

                 else:
                     if _parent == self.header:
                          self.header.parent = root.left
                     elif _parent.left == root:
                         _parent.left = root.left
                     else:
                         _parent.right = root.left

                     if root.left is not None:
                         root.left.parent = _parent;


                 _parent.balance_tree_remove(_from)
                 return True;

    def remove(self,data):
       success = self.remove_first(data)
       while success:
          success = self.remove_first(data)

    def remove_node(self, root):

        if root.left != None and root.right != None:
            replace = root.left
            while replace.right != None:
               replace = replace.right
            root.swap_nodes(replace)

        parent = root.parent;

        if parent.left == root:
           next_from = direction.from_left
        else:
           next_from = direction.from_right

        if self.header.left == root:
            n = root.next()

            if n.is_header():
                self.header.left = self.header;
                self.header.right = self.header
            else:
                self.header.left = n
        elif self.header.right == root:
             p = root.previous()

             if p.is_header():
                root.header.left = root.header
                root.header.right = header
             else:
                self.header.right = p

        if root.left == None:
            if parent == self.header:
                self.header.parent = root.right
            elif parent.left == root:
                parent.left = root.right
            else:
                parent.right = root.right

            if root.right != None:
               root.right.parent = parent
        else:
            if parent == self.header:
                self.header.parent = root.left
            elif parent.left == root:
                parent.left = root.left
            else:
                parent.right = root.left

            if root.left != None:
               root.left.parent = parent;

        parent.balance_tree_remove(next_from)

    def remove_at(self, data, ophset):

            p = self.search(data);

            if p == None:
                return
            else:
                lower = p
                after = after(data)

            s = 0
            while True:
                if ophset == s:
                    remove_node(lower);
                    return;
                lower = lower.next_node()
                if after == lower:
                   break
                s = s+1

            return

    def search(self, key):
        s = before(key)
        s.next()
        if s.is_header():
           return None
        c = s.compare(s.key)
        if c != 0:
           return None
        return s


    def before(self, data):
        y = self.header;
        x = self.header.parent;

        while x != None:
            if x.compare(data) >= 0:
                x = x.left;
            else:
                y = x;
                x = x.right;
        return y

    def after(self, data):
        y = self.header;
        x = self.header.parent;

        while x != None:
            if x.compare(data) > 0:
                y = x
                x = x.left
            else:
                x = x.right

        return y;


    def find(self,data):
        root = self.header.parent;

        results = array()

        while True:
            if root is None:
                break;

            p = self.before(data)
            p = p.next()
            if not p.is_header():
               i = p
               l = self.after(data)
               while i != l:
                  results.push(i.key)
                  i = i.next()

               return results
            else:
               break;

        return results

class bag_dictionary:

    def __init__(self):
        self.bag = bag()
        return None

    def add(self, key, value):
       self.bag.add(key_value(key,value))
       return

    def remove(self, key):
       self.bag.remove(key_value(key,None))
       return

    def remove_at(self, key, index):
       self.bag.remove_at(key_value(key,None), index)
       return

    def clear(self):
       self.bag.header = node()

    def __len__(self):
        return self.bag.header.parent.length()

    def __str__(self):
       l = self.bag.header.right;
       s = "{"
       i = self.bag.header.left;
       h = self.bag.header;
       while i != h:
           s = s + "("
           s = s + i.key.key.__str__()
           s = s + ","
           s = s + i.key.value.__str__()
           s = s + ")"
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s;

    def __iter__(self):

        self.bag.node = self.bag.header
        return self

    def __next__(self):
        self.bag.node = self.bag.node.next()
        if self.bag.node.is_header():
            raise StopIteration
        return key_value(self.bag.node.key.key,self.bag.node.key.value)

    def __getitem__(self, key):
          kv_array = self.bag.find(key_value(key,None))
          return kv_array

    def __setitem__(self, key, value):
          self.add(key,value)
          return

    def __delitem__(self, key):
          self.bag.remove(key_value(key,None))

class unordered_set:

    def __init__(self):
        self.bag_dictionary = bag_dictionary()

    def __len__(self):
        return self.bag_dictionary.__len__()

    def __hash__(self):
        h = 0
        for i in self:
            h = h + i.__hash__()
        return h

    def __eq__(self, other):
        for t in self:
           if not other.contains(t):
              return False
        for u in other:
           if self.contains(u):
              return False
        return true;

    def __ne__(self, other):
        return not self == other

    def __or__(self, other):
       r = unordered_set()

       for t in self:
          r.add(t);

       for u in other:
          if not self.contains(u):
             r.add(u);

       return r

    def __and__(self, other):
       r = unordered_set()

       for t in self:
          if other.contains(t):
              r.add(t)

       for u in other:
              if self.contains(u) and not r.contains(u):
                  r.add(u);

       return r

    def __xor__(self, other):
       r = unordered_set()

       for t in self:
          if not other.contains(t):
             r.add(t)

       for u in other:
          if not self.contains(u) and not r.contains(u):
             r.add(u)

       return r


    def __sub__(self, other):
       r = ordered_set()

       for t in self:
          if not other.contains(t):
             r.add(t);

       return r

    def __lshift__(self, data):
       self.add(data)
       return self

    def __rshift__(self, data):
       self.remove(data)
       return self

    def __getitem__(self, key):
          return self.contains(key)

    def is_subset(self, other):

       is_subet = True

       for t in self:
          if not other.contains(t):
             subset = False
             break

       return is_subet

    def is_superset(self,other):
       return other.is_subset(self)


    def add(self, value):
       if not self.contains(value):
           self.bag_dictionary.add(hash(value),value)
       else:
          raise entry_already_exists("Entry already exists in the unordered set")

    def contains(self, data):
            if self.bag_dictionary.bag.header.parent == None:
                return False;
            else:
                index = hash(data);

                _search = self.bag_dictionary.bag.header.parent;

                search_index =  _search.key.key;

                if index < search_index:
                   _search = _search.left

                elif index > search_index:
                   _search = _search.right

                if _search == None:
                    return False

                while _search != None:
                    search_index =  _search.key.key;

                    if index < search_index:
                       _search = _search.left

                    elif index > search_index:
                       _search = _search.right

                    else:
                       break

                if _search == None:
                   return False

                return self.contains_node(data, _search)

    def contains_node(self,data,_node):

        previous = _node.previous()
        save = _node

        while not previous.is_header() and previous.key.key == _node.key.key:
            save = previous;
            previous = previous.previous()

        c = _node.key.value
        _node = save
        if c == data:
           return True

        next = _node.next()
        while not next.is_header() and next.key.key == _node.key.key:
            _node = next
            c = _node.key.value
            if c == data:
               return True;
            next = _node.next()

        return False;

    def find(self,data,_node):

        previous = _node.previous()
        save = _node

        while not previous.is_header() and previous.key.key == _node.key.key:
            save = previous;
            previous = previous.previous();

        _node = save;
        c = _node.key.value
        if c == data:
           return _node

        next = _node.next()
        while not next.is_header() and next.key.key == _node.key.key:
            _node = next
            c = _node.data.value
            if c == data:
               return _node
            next = _node.next()

        return None

    def search(self, data):
        if self.bag_dictionary.bag.header.parent == None:
            return None
        else:
            index = hash(data)

            _search = self.bag_dictionary.bag.header.parent

            c = _search.key.key

            if index < c:
               _search = _search.left;

            elif index > c:
               _search = _search.right;

            while _search != None:

                if index != c:
                   break

                c = _search.key.key

                if index < c:
                   _search = _search.left;

                elif index > c:
                   _search = _search.right;

                else:
                   break

            if _search == None:
               return None

            return self.find(data, _search)

    def remove(self,data):
       found = self.search(data);
       if found != None:
          self.bag_dictionary.bag.remove_node(found);
       else:
          raise entry_not_found("Entry not found in the unordered set")

    def clear(self):
       self.bag_dictionary.bag.header = node()

    def __str__(self):
       l = self.bag_dictionary.bag.header.right;
       s = "{"
       i = self.bag_dictionary.bag.header.left;
       h = self.bag_dictionary.bag.header;
       while i != h:
           s = s + i.key.value.__str__()
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s;

    def __iter__(self):

        self.bag_dictionary.bag.node = self.bag_dictionary.bag.header
        return self

    def __next__(self):
        self.bag_dictionary.bag.node = self.bag_dictionary.bag.node.next()
        if self.bag_dictionary.bag.node.is_header():
            raise StopIteration
        return self.bag_dictionary.bag.node.key.value


class map:

    def __init__(self):
        self.set = unordered_set()
        return None

    def __len__(self):
        return self.set.__len__()

    def add(self, key, value):
       try:
           self.set.remove(key_value(key,None))
       except entry_not_found:
            pass
       self.set.add(key_value(key,value))
       return

    def remove(self, key):
       self.set.remove(key_value(key,None))
       return

    def clear(self):
       self.set.clear()

    def __str__(self):
       l = self.set.bag_dictionary.bag.header.right;
       s = "{"
       i = self.set.bag_dictionary.bag.header.left;
       h = self.set.bag_dictionary.bag.header;
       while i != h:
           s = s + "("
           s = s + i.key.value.key.__str__()
           s = s + ","
           s = s + i.key.value.value.__str__()
           s = s + ")"
           if i != l:
               s = s + ","
           i = i.next()

       s = s + "}"
       return s;

    def __iter__(self):

        self.set.node = self.set.bag_dictionary.bag.header
        return self

    def __next__(self):
        self.set.node = self.set.node.next()
        if self.set.node.is_header():
            raise StopIteration
        return key_value(self.set.node.key.key,self.set.node.key.value)

    def __getitem__(self, key):
          kv = self.set.find(key_value(key,None))
          return kv.value

    def __setitem__(self, key, value):
          self.add(key,value)
          return

    def __delitem__(self, key):
          self.remove(key)
