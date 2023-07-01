var stripChars = Fn.new { |s, t|
    return s.map { |c|
        return (t.indexOf(c) == -1) ? c : ""
    }.join()
}

System.print(stripChars.call("She was a soul stripper. She took my heart!", "aei"))
