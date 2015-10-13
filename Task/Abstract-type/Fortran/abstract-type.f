   ! abstract derived type
   type, abstract :: TFigure
      real(rdp) :: area
   contains
      ! deferred method i.e. abstract method =  must be overridden in extended type
      procedure(calculate_area), deferred, pass :: calculate_area
   end type TFigure
   ! only declaration of the abstract method/procedure for TFigure type
   abstract interface
      function  calculate_area(this)
         import TFigure !imports TFigure type from host scoping unit and makes it accessible here
         implicit none
         class(TFigure) :: this
         real(rdp) :: calculate_area
      end function calculate_area
   end interface
