enum Compass {
    N, NbE, NNE, NEbN, NE, NEbE, ENE, EbN,
    E, EbS, ESE, SEbE, SE, SEbS, SSE, SbE,
    S, SbW, SSW, SWbS, SW, SWbW, WSW, WbS,
    W, WbN, WNW, NWbW, NW, NWbN, NNW, NbW;

    float midpoint() {
        float midpoint = (360 / 32f) * ordinal();
        return midpoint == 0 ? 360 : midpoint;
    }

    float[] bounds() {
        float bound = (360 / 32f) / 2f;
        float midpoint = midpoint();
        float boundA = midpoint - bound;
        float boundB = midpoint + bound;
        if (boundB > 360) boundB -= 360;
        return new float[] { boundA, boundB };
    }

    static Compass parse(float degrees) {
        float[] bounds;
        float[] boundsN = N.bounds();
        for (Compass value : Compass.values()) {
            bounds = value.bounds();
            if (degrees >= boundsN[0] || degrees < boundsN[1])
                return N;
            if (degrees >= bounds[0] && degrees < bounds[1])
                return value;
        }
        return null;
    }

    @Override
    public String toString() {
        String[] strings = new String[name().length()];
        int index = 0;
        for (char letter : name().toCharArray()) {
            switch (letter) {
                case 'N' -> strings[index] = "north";
                case 'E' -> strings[index] = "east";
                case 'S' -> strings[index] = "south";
                case 'W' -> strings[index] = "west";
                case 'b' -> strings[index] = "by";
            }
            index++;
        }
        String string
            = strings[0].substring(0, 1).toUpperCase() +
              strings[0].substring(1);
        switch (strings.length) {
            case 2 -> string += strings[1];
            case 3 -> {
                if (strings[1].equals("by")) {
                    string += " %s %s".formatted(strings[1], strings[2]);
                } else {
                    string += "-%s%s".formatted(strings[1], strings[2]);
                }
            }
            case 4 -> {
                string += String.join(" ", strings[1], strings[2], strings[3]);
            }
        }
        return string;
    }
}
