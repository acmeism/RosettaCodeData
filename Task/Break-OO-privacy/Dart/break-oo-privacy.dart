class CFactory {
  int _count = 0;

  CFactory();

  int get count => _count;

  CWidget getWidget() {
    return CWidget._(this);
  }
}

class CWidget {
  final CFactory _parent;

  // Private constructor - only accessible from CFactory
  CWidget._(this._parent) {
    _parent._count++;
    print('Widget spawning. There are now ${_parent._count} Widgets instantiated.');
  }

  void dispose() {
    _parent._count--;
    print('Widget dying. There are now ${_parent._count} Widgets instantiated.');
  }
}

void main() {
  final factory = CFactory();

  final widget1 = factory.getWidget();
  final widget2 = factory.getWidget();
  widget1.dispose();

  final widget3 = factory.getWidget();
  widget3.dispose();
  widget2.dispose();
}
