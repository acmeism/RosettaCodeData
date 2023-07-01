class Parent(object):
    __priv = 'private'

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return '%s(%s)' % (type(self).__name__, self.name)

    def doNothing(self):
        pass

import re

class Child(Parent):
    # prefix for "private" fields
    __rePrivate = re.compile('^_(Child|Parent)__')
    # used when setting dynamic property values
    __reBleh = re.compile('\Wbleh$')
    @property
    def reBleh(self):
        return self.__reBleh

    def __init__(self, name, *args):
        super(Child, self).__init__(name)
        self.args = args

    def __dir__(self):
        myDir = filter(
            # filter out private fields
            lambda p: not self.__rePrivate.match(p),
            list(set( \
                sum([dir(base) for base in type(self).__bases__], []) \
                + type(self).__dict__.keys() \
                + self.__dict__.keys() \
            )))
        return myDir + map(
            # dynamic properties
            lambda p: p + '_bleh',
            filter(
                # don't add dynamic properties for methods and other special properties
                lambda p: (p[:2] != '__' or p[-2:] != '__') and not callable(getattr(self, p)),
                myDir))

    def __getattr__(self, name):
        if name[-5:] == '_bleh':
            # dynamic '_bleh' properties
            return str(getattr(self, name[:-5])) + ' bleh'
        if hasattr(super(Child, chld), '__getattr__'):
            return super(Child, self).__getattr__(name)
        raise AttributeError("'%s' object has no attribute '%s'" % (type(self).__name__, name))

    def __setattr__(self, name, value):
        if name[-5:] == '_bleh':
            # skip backing properties that are methods
            if not (hasattr(self, name[:-5]) and callable(getattr(self, name[:-5]))):
                setattr(self, name[:-5], self.reBleh.sub('', value))
        elif hasattr(super(Child, self), '__setattr__'):
            super(Child, self).__setattr__(name, value)
        elif hasattr(self, '__dict__'):
            self.__dict__[name] = value

    def __repr__(self):
        return '%s(%s, %s)' % (type(self).__name__, self.name, str(self.args).strip('[]()'))

    def doStuff(self):
        return (1+1.0/1e6) ** 1e6

par = Parent('par')
par.parent = True
dir(par)
#['_Parent__priv', '__class__', ..., 'doNothing', 'name', 'parent']
inspect.getmembers(par)
#[('_Parent__priv', 'private'), ('__class__', <class '__main__.Parent'>), ..., ('doNothing', <bound method Parent.doNothing of <__main__.Parent object at 0x100777650>>), ('name', 'par'), ('parent', True)]

chld = Child('chld', 0, 'I', 'two')
chld.own = "chld's own"
dir(chld)
#['__class__', ..., 'args', 'args_bleh', 'doNothing', 'doStuff', 'name', 'name_bleh', 'own', 'own_bleh', 'reBleh', 'reBleh_bleh']
inspect.getmembers(chld)
#[('__class__', <class '__main__.Child'>), ..., ('args', (0, 'I', 'two')), ('args_bleh', "(0, 'I', 'two') bleh"), ('doNothing', <bound method Child.doNothing of Child(chld, 0, 'I', 'two')>), ('doStuff', <bound method Child.doStuff of Child(chld, 0, 'I', 'two')>), ('name', 'chld'), ('name_bleh', 'chld bleh'), ('own', "chld's own"), ('own_bleh', "chld's own bleh"), ('reBleh', <_sre.SRE_Pattern object at 0x10067bd20>), ('reBleh_bleh', '<_sre.SRE_Pattern object at 0x10067bd20> bleh')]
