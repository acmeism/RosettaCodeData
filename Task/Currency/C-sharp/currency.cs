using System;
using System.Collections.Generic;

namespace Currency
{
    class Program
    {
        static void Main(string[] args)
        {
            MenuItem hamburger = new MenuItem() { Name = "Hamburger", Price = 5.5M };
            MenuItem milkshake = new MenuItem() { Name = "Milkshake", Price = 2.86M };

            IList<CartItem> cart = new List<CartItem>();
            cart.Add(new CartItem() { item = hamburger, quantity = 4000000000000000 });
            cart.Add(new CartItem() { item = milkshake, quantity = 2 });

            decimal total = CalculateTotal(cart);

            Console.WriteLine(string.Format("Total before tax: {0:C}", total));

            // Add Tax
            decimal tax = total * 0.0765M;

            Console.WriteLine(string.Format("Tax: {0:C}", tax));

            total += tax;

            Console.WriteLine(string.Format("Total with tax: {0:C}", total));
        }

        private static decimal CalculateTotal(IList<CartItem> cart)
        {
            decimal total = 0M;

            foreach (CartItem item in cart)
            {
                total += item.quantity * item.item.Price;
            }

            return total;
        }

        private struct MenuItem
        {
            public string Name { get; set; }
            public decimal Price { get; set; }
        }

        private struct CartItem
        {
            public MenuItem item { get; set; }
            public decimal quantity { get; set; }
        }
    }
}
