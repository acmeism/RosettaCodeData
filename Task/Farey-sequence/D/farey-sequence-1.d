    string toString() const /*pure nothrow*/ {
        if (den != 0)
            //return num.text ~ (den == 1 ? "" : "/" ~ den.text);
            return num.text ~ "/" ~ den.text;
        if (num == 0)
            return "NaRat";
        else
            return ((num < 0) ? "-" : "+") ~ "infRat";
    }
