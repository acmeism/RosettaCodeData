using System;
using System.Collections.Generic;

namespace StableMarriage
{
    class Person
    {
        private int _candidateIndex;
        public string Name { get; set; }
        public List<Person> Prefs { get; set; }
        public Person Fiance { get; set; }

        public Person(string name) {
            Name = name;
            Prefs = null;
            Fiance = null;
            _candidateIndex = 0;
        }
        public bool Prefers(Person p) {
            return Prefs.FindIndex(o => o == p) < Prefs.FindIndex(o => o == Fiance);
        }
        public Person NextCandidateNotYetProposedTo() {
            if (_candidateIndex >= Prefs.Count) return null;
            return Prefs[_candidateIndex++];
        }
        public void EngageTo(Person p) {
            if (p.Fiance != null) p.Fiance.Fiance = null;
            p.Fiance = this;
            if (Fiance != null) Fiance.Fiance = null;
            Fiance = p;
        }
    }

    static class MainClass
    {
        static public bool IsStable(List<Person> men) {
            List<Person> women = men[0].Prefs;
            foreach (Person guy in men) {
                foreach (Person gal in women) {
                    if (guy.Prefers(gal) && gal.Prefers(guy))
                        return false;
                }
            }
            return true;
        }

        static void DoMarriage() {
            Person abe  = new Person("abe");
            Person bob  = new Person("bob");
            Person col  = new Person("col");
            Person dan  = new Person("dan");
            Person ed   = new Person("ed");
            Person fred = new Person("fred");
            Person gav  = new Person("gav");
            Person hal  = new Person("hal");
            Person ian  = new Person("ian");
            Person jon  = new Person("jon");
            Person abi  = new Person("abi");
            Person bea  = new Person("bea");
            Person cath = new Person("cath");
            Person dee  = new Person("dee");
            Person eve  = new Person("eve");
            Person fay  = new Person("fay");
            Person gay  = new Person("gay");
            Person hope = new Person("hope");
            Person ivy  = new Person("ivy");
            Person jan  = new Person("jan");

            abe.Prefs  = new List<Person>() {abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay};
            bob.Prefs  = new List<Person>() {cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay};
            col.Prefs  = new List<Person>() {hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan};
            dan.Prefs  = new List<Person>() {ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi};
            ed.Prefs   = new List<Person>() {jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay};
            fred.Prefs = new List<Person>() {bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay};
            gav.Prefs  = new List<Person>() {gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay};
            hal.Prefs  = new List<Person>() {abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee};
            ian.Prefs  = new List<Person>() {hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve};
            jon.Prefs  = new List<Person>() {abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope};
            abi.Prefs  = new List<Person>() {bob, fred, jon, gav, ian, abe, dan, ed, col, hal};
            bea.Prefs  = new List<Person>() {bob, abe, col, fred, gav, dan, ian, ed, jon, hal};
            cath.Prefs = new List<Person>() {fred, bob, ed, gav, hal, col, ian, abe, dan, jon};
            dee.Prefs  = new List<Person>() {fred, jon, col, abe, ian, hal, gav, dan, bob, ed};
            eve.Prefs  = new List<Person>() {jon, hal, fred, dan, abe, gav, col, ed, ian, bob};
            fay.Prefs  = new List<Person>() {bob, abe, ed, ian, jon, dan, fred, gav, col, hal};
            gay.Prefs  = new List<Person>() {jon, gav, hal, fred, bob, abe, col, ed, dan, ian};
            hope.Prefs = new List<Person>() {gav, jon, bob, abe, ian, dan, hal, ed, col, fred};
            ivy.Prefs  = new List<Person>() {ian, col, hal, gav, fred, bob, abe, ed, jon, dan};
            jan.Prefs  = new List<Person>() {ed, hal, gav, abe, bob, jon, col, ian, fred, dan};

            List<Person> men = new List<Person>(abi.Prefs);

            int freeMenCount = men.Count;
            while (freeMenCount > 0) {
                foreach (Person guy in men) {
                    if (guy.Fiance == null) {
                        Person gal = guy.NextCandidateNotYetProposedTo();
                        if (gal.Fiance == null) {
                            guy.EngageTo(gal);
                            freeMenCount--;
                        } else if (gal.Prefers(guy)) {
                            guy.EngageTo(gal);
                        }
                    }
                }
            }

            foreach (Person guy in men) {
                Console.WriteLine("{0} is engaged to {1}", guy.Name, guy.Fiance.Name);
            }
            Console.WriteLine("Stable = {0}", IsStable(men));

            Console.WriteLine("\nSwitching fred & jon's partners");
            Person jonsFiance = jon.Fiance;
            Person fredsFiance = fred.Fiance;
            fred.EngageTo(jonsFiance);
            jon.EngageTo(fredsFiance);
            Console.WriteLine("Stable = {0}", IsStable(men));
        }

        public static void Main(string[] args)
        {
            DoMarriage();
        }
    }
}
