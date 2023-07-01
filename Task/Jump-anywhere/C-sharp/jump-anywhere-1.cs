if (x > 0) goto positive;
else goto negative;

positive:
    Console.WriteLine("pos\n"); goto both;

negative:
    Console.WriteLine("neg\n");

both:
    ...
