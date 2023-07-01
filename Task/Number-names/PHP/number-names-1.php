$orderOfMag = array('Hundred', 'Thousand,', 'Million,', 'Billion,', 'Trillion,');
$smallNumbers = array('Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen');
$decades = array('', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety');

function NumberToEnglish($num, $count = 0){
   global $orderOfMag, $smallNumbers, $decades;
   $isLast = true;
   $str = '';

   if ($num < 0){
      $str = 'Negative ';
      $num = abs($num);
   }

   (int) $thisPart = substr((string) $num, -3);

   if (strlen((string) $num) > 3){
      // Number still too big, work on a smaller chunk
      $str .= NumberToEnglish((int) substr((string) $num, 0, strlen((string) $num) - 3), $count + 1);
      $isLast = false;
   }

   // do translation stuff
   if (($count == 0 || $isLast) && ($str == '' || $str == 'Negative '))
      // This is either a very small number or the most significant digits of the number. Either way we don't want a preceeding "and"
      $and = '';
   else
      $and = ' and ';

   if ($thisPart > 99){
      // Hundreds part of the number chunk
      $str .= ($isLast ? '' : ' ') . "{$smallNumbers[$thisPart/100]} {$orderOfMag[0]}";

      if(($thisPart %= 100) == 0){
         // There is nothing else to do for this chunk (was a multiple of 100)
         $str .= " {$orderOfMag[$count]}";
         return $str;
      }
      $and = ' and ';  // Set up our and string to the word "and" since there is something in the hundreds place of this chunk
   }

   if ($thisPart >= 20){
      // Tens part of the number chunk
      $str .= "{$and}{$decades[$thisPart /10]}";
      $and = ' '; // Make sure we don't have any extranious "and"s
      if(($thisPart %= 10) == 0)
         return $str . ($count != 0 ? " {$orderOfMag[$count]}" : '');
   }

   if ($thisPart < 20 && $thisPart > 0)
      // Ones part of the number chunk
      return $str . "{$and}{$smallNumbers[(int) $thisPart]} " . ($count != 0 ? $orderOfMag[$count] : '');
   elseif ($thisPart == 0 && strlen($thisPart) == 1)
      // The number is zero
      return $str . "{$smallNumbers[(int)$thisPart]}";
}
