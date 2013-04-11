functor
import Application System
define
   ArgList = {Application.getArgs plain}
   {ForAll ArgList System.showInfo}
   {Application.exit 0}
end
