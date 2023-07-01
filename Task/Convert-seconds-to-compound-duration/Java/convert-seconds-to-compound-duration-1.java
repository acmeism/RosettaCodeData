String duration(int seconds) {
    StringBuilder string = new StringBuilder();
    if (seconds >= 604_800 /* 1 wk */) {
        string.append("%,d wk".formatted(seconds / 604_800));
        seconds %= 604_800;
    }
    if (seconds >= 86_400 /* 1 d */) {
        if (!string.isEmpty()) string.append(", ");
        string.append("%d d".formatted(seconds / 86_400));
        seconds %= 86_400;
    }
    if (seconds >= 3600 /* 1 hr */) {
        if (!string.isEmpty()) string.append(", ");
        string.append("%d hr".formatted(seconds / 3600));
        seconds %= 3600;
    }
    if (seconds >= 60 /* 1 min */) {
        if (!string.isEmpty()) string.append(", ");
        string.append("%d min".formatted(seconds / 60));
        seconds %= 60;
    }
    if (seconds > 0) {
        if (!string.isEmpty()) string.append(", ");
        string.append("%d sec".formatted(seconds));
    }
    return string.toString();
}
