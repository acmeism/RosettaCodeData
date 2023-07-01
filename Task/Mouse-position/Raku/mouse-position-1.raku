use java::awt::MouseInfo:from<java>;

given MouseInfo.getPointerInfo.getLocation {
    say .getX, 'x', .getY;
}
