variable door,
    isOpen = Char_Type [101],
    pass;

for (door = 1; door <= 100; door++) {
    isOpen[door] = 0;
}

for (pass = 1; pass <= 100; pass++) {
    for (door = pass; door <= 100; door += pass) {
        isOpen[door] = not isOpen[door];
    }
}

for (door = 1; door <= 100; door++) {
    if (isOpen[door]) {
        print("Door " + string(door) + ":open");
    } else {
        print("Door " + string(door) + ":close");
    }
}
