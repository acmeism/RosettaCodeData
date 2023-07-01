function Get-DoorState($NumberOfDoors)
{
   begin
   {
      $Doors = @()
      $Multiple = 1
   }

   process
   {
      for ($i = 1; $i -le $NumberOfDoors; $i++)
      {
         $Door = [pscustomobject]@{
                    Name = $i
                    Open = $false
                 }

         $Doors += $Door
      }

      While ($Multiple -le $NumberOfDoors)
      {
	 Foreach ($Door in $Doors)
	 {
	    if ($Door.name % $Multiple -eq 0)
               {
	          If ($Door.open -eq $False){$Door.open = $True}
	          Else {$Door.open = $False}
	       }
	 }
			
         $Multiple++
      }
    }

    end {$Doors}
}
