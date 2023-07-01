switch (value)
{
   case 1:
          // Some task
          goto case 2; // will cause the code indicated in case 2 to be executed.
   case 2:
          // Some task
          break;
   case 3:
         // Some task
         break;
   default: // If no other case is matched.
         // Some task
         break;
}
