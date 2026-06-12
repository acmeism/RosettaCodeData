//Aamrun, 4th October 2021

#include <iostream>
using namespace std;

class Cuboid {

   private:
      double length;
      double breadth;
      double height;

   public:
      double getVolume(void) {
         return length * breadth * height;
      }
      void setLength( double l ) {
         length = l;
      }
      void setBreadth( double b ) {
         breadth = b;
      }
      void setHeight( double h ) {
         height = h;
      }


      Cuboid operator +(const Cuboid& c) {
         Cuboid biggerCuboid;
         biggerCuboid.length = this->length + c.length;
         biggerCuboid.breadth = this->breadth + c.breadth;
         biggerCuboid.height = this->height + c.height;
         return biggerCuboid;
      }

      Cuboid operator -(const Cuboid& c) {
         Cuboid smallerCuboid;
         smallerCuboid.length = this->length - c.length;
         smallerCuboid.breadth = this->breadth - c.breadth;
         smallerCuboid.height = this->height - c.height;
         return smallerCuboid;
      }
};

int main() {
   Cuboid c1;
   Cuboid c2;
   Cuboid c3;
   double volume = 0.0;

   c1.setLength(6.0);
   c1.setBreadth(7.0);
   c1.setHeight(5.0);

   c2.setLength(12.0);
   c2.setBreadth(13.0);
   c2.setHeight(10.0);

   volume = c1.getVolume();
   std::cout << "Volume of 1st cuboid : " << volume <<endl;

   volume = c2.getVolume();
   std::cout << "Volume of 2nd cuboid : " << volume <<endl;

   //Adding the two cuboids
   c3 = c1 + c2;

   volume = c3.getVolume();
   std::cout << "Volume of 3rd cuboid after adding : " << volume <<endl;

   //Subtracting the two cuboids
   c3 = c1 - c2;

   volume = c3.getVolume();
   std::cout << "Volume of 3rd cuboid after subtracting : " << volume <<endl;

   return 0;
}
