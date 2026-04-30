using namespace System.Collections.Generic
$ErrorActionPreference = 'Stop'
class Person{
    #private
    hidden [int] $_candidateIndex;
    [string] $Name
    #[System.Collections.Generic.List[Person]] $Prefs
    [List[Person]] $Prefs
    [Person] $Fiance

    Person([string] $name) {
            $this.Name = $name;
            $this.Prefs = $null;
            $this.Fiance = $null;
            $this._candidateIndex = 0;
        }
    [bool] Prefers([Person] $p) {
            return $this.Prefs.FindIndex({ param($o) $o -eq $p }) -lt $this.Prefs.FindIndex({ param($o) $o -eq $this.Fiance });
        }

    [Person] NextCandidateNotYetProposedTo() {
            if ($this._candidateIndex -ge $this.Prefs.Count) {return $null;}
            return $this.Prefs[$this._candidateIndex++];
        }

    [void] EngageTo([Person] $p) {
            if ($p.Fiance -ne $null) {$p.Fiance.Fiance = $null};
            $p.Fiance = $this;
            if ($this.Fiance -ne $null){$this.Fiance.Fiance = $null};
            $this.Fiance = $p;
        }


    }


    class MainClass
    {
        static  [bool] IsStable([List[Person]] $men) {
            [List[Person]] $women = $men[0].Prefs;
            foreach ($guy in $men){
                foreach ($gal in $women) {
                    if ($guy.Prefers($gal) -and $gal.Prefers($guy))
                        {return $false};
                }
            }
            return $true;
        }

        static [void] DoMarriage() {
            [Person] $abe  = [Person]::new("abe");
            [Person] $bob  = [Person]::new("bob");
            [Person] $col  = [Person]::new("col");
            [Person] $dan  = [Person]::new("dan");
            [Person] $ed   = [Person]::new("ed");
            [Person] $fred = [Person]::new("fred");
            [Person] $gav  = [Person]::new("gav");
            [Person] $hal  = [Person]::new("hal");
            [Person] $ian  = [Person]::new("ian");
            [Person] $jon  = [Person]::new("jon");
            [Person] $abi  = [Person]::new("abi");
            [Person] $bea  = [Person]::new("bea");
            [Person] $cath = [Person]::new("cath");
            [Person] $dee  = [Person]::new("dee");
            [Person] $eve  = [Person]::new("eve");
            [Person] $fay  = [Person]::new("fay");
            [Person] $gay  = [Person]::new("gay");
            [Person] $hope = [Person]::new("hope");
            [Person] $ivy  = [Person]::new("ivy");
            [Person] $jan  = [Person]::new("jan");

            $abe.Prefs =[Person[]]@($abi, $eve, $cath, $ivy, $jan, $dee, $fay, $bea, $hope, $gay)
            $bob.Prefs  = [Person[]] @($cath, $hope, $abi, $dee, $eve, $fay, $bea, $jan, $ivy, $gay);
            $col.Prefs  = [Person[]] @($hope, $eve, $abi, $dee, $bea, $fay, $ivy, $gay, $cath, $jan);
            $dan.Prefs  = [Person[]] @($ivy, $fay, $dee, $gay, $hope, $eve, $jan, $bea, $cath, $abi);
            $ed.Prefs   = [Person[]] @($jan, $dee, $bea, $cath, $fay, $eve, $abi, $ivy, $hope, $gay);
            $fred.Prefs = [Person[]] @($bea, $abi, $dee, $gay, $eve, $ivy, $cath, $jan, $hope, $fay);
            $gav.Prefs  = [Person[]] @($gay, $eve, $ivy, $bea, $cath, $abi, $dee, $hope, $jan, $fay);
            $hal.Prefs  = [Person[]] @($abi, $eve, $hope, $fay, $ivy, $cath, $jan, $bea, $gay, $dee);
            $ian.Prefs  = [Person[]] @($hope, $cath, $dee, $gay, $bea, $abi, $fay, $ivy, $jan, $eve);
            $jon.Prefs  = [Person[]] @($abi, $fay, $jan, $gay, $eve, $bea, $dee, $cath, $ivy, $hope);
            $abi.Prefs  = [Person[]] @($bob, $fred, $jon, $gav, $ian, $abe, $dan, $ed, $col, $hal);
            $bea.Prefs  = [Person[]] @($bob, $abe, $col, $fred, $gav, $dan, $ian, $ed, $jon, $hal);
            $cath.Prefs = [Person[]] @($fred, $bob, $ed, $gav, $hal, $col, $ian, $abe, $dan, $jon);
            $dee.Prefs  = [Person[]] @($fred, $jon, $col, $abe, $ian, $hal, $gav, $dan, $bob, $ed);
            $eve.Prefs  = [Person[]] @($jon, $hal, $fred, $dan, $abe, $gav, $col, $ed, $ian, $bob);
            $fay.Prefs  = [Person[]] @($bob, $abe, $ed, $ian, $jon, $dan, $fred, $gav, $col, $hal);
            $gay.Prefs  = [Person[]] @($jon, $gav, $hal, $fred, $bob, $abe, $col, $ed, $dan, $ian);
            $hope.Prefs = [Person[]] @($gav, $jon, $bob, $abe, $ian, $dan, $hal, $ed, $col, $fred);
            $ivy.Prefs  = [Person[]] @($ian, $col, $hal, $gav, $fred, $bob, $abe, $ed, $jon, $dan);
            $jan.Prefs  = [Person[]] @($ed, $hal, $gav, $abe, $bob, $jon, $col, $ian, $fred, $dan);

            [List[Person]] $men = [List[Person]]::new($abi.Prefs);

            [int] $freeMenCount = $men.Count;
            while ($freeMenCount -gt 0) {
                foreach ($guy in $men) {
                    if ($guy.Fiance -eq $null) {
                        [Person]$gal = $guy.NextCandidateNotYetProposedTo();
                        if ($gal.Fiance -eq $null) {
                            $guy.EngageTo($gal);
                            $freeMenCount--;
                        }
                        else{
                            if ($gal.Prefers($guy)) {
                                $guy.EngageTo($gal);
                            }
                        }

                    }
                }
            }

            foreach ($guy in $men) {
                write-host $guy.Name " is engaged to " $guy.Fiance.Name

            }
            write-host "Stable = " ([MainClass]::IsStable($men))

            write-host "Switching fred & jon's partners";
            [Person] $jonsFiance = $jon.Fiance;
            [Person] $fredsFiance = $fred.Fiance;
            $fred.EngageTo($jonsFiance);
            $jon.EngageTo($fredsFiance);
            write-host "Stable = " ([MainClass]::IsStable($men));

        }
     static [void] Main([string[]] $args)
        {
            [MainClass]::DoMarriage();
        }


    }

[MainClass]::DoMarriage()
