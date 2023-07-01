using System.Collections.Generic;

class FoodBox<T> where T : IEatable
{
    List<T> food;
}
