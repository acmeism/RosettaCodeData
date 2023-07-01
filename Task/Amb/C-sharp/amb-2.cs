    // original problem
    using (Amb amb = new Amb())
    {
        var set1 = amb.DefineValues("the", "that", "a");
        var set2 = amb.DefineValues("frog", "elephant", "thing");
        var set3 = amb.DefineValues("walked", "treaded", "grows");
        var set4 = amb.DefineValues("slowly", "quickly");

        amb.Assert(() => IsJoinable(set1.Value, set2.Value));
        amb.Assert(() => IsJoinable(set2.Value, set3.Value));
        amb.Assert(() => IsJoinable(set3.Value, set4.Value));

        amb.Perform(() =>
            {
                System.Console.WriteLine("{0} {1} {2} {3}", set1.Value, set2.Value, set3.Value, set4.Value);
                amb.Stop();
            });
    }
    // problem from http://www.randomhacks.net/articles/2005/10/11/amb-operator
    using (Amb amb = new Amb())
    {
        IAmbValue<int> x = amb.DefineValues(1, 2, 3);
        IAmbValue<int> y = amb.DefineValues(4, 5, 6);
        amb.Assert(() => x.Value * y.Value == 8);
        amb.Perform(() =>
            {
                System.Console.WriteLine("{0} {1}", x.Value, y.Value);
                amb.Stop();
            });
    }
