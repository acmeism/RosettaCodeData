using System.Collections.Generic

class FoodMakingBox<T> where T : IEatable, new()
{
    List<T> food;

    void Make(int numberOfFood)
    {
        this.food = new List<T>();
        for (int i = 0; i < numberOfFood; i++)
        {
            this.food.Add(new T());
        }
    }
}
