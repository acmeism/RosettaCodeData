#include <iostream>
#include "xtensor/xarray.hpp"
#include "xtensor/xio.hpp"
#include "xtensor-io/ximage.hpp"

xt::xarray<int> init_grid (unsigned long x_dim, unsigned long y_dim)
{
    xt::xarray<int>::shape_type shape = { x_dim, y_dim };
    xt::xarray<int> grid(shape);

    grid(x_dim/2, y_dim/2) = 64000;

    return grid;
}

int print_grid(xt::xarray<int>& grid)
{
    // for output to the terminal uncomment next line
    // only makes sense for small grid < 32x32;
    // std::cout << grid << std::endl << std::endl;

    // output result to an image
    xt::dump_image("grid.jpg", grid);

    return 0;
}

bool iterate_grid(xt::xarray<int>& grid, const unsigned long& x_dim, const unsigned long& y_dim)
{
    bool changed = false;

    for (unsigned long i=0; i < x_dim; ++i)
    {
        for (unsigned long j=0; j < y_dim; ++j)
        {
            if ( grid(i, j) >= 4 )
            {
                grid(i, j) -= 4;
                changed = true;
                try
                {
                    grid.at(i-1, j) += 1;
                    grid.at(i+1, j) += 1;
                    grid.at(i, j-1) += 1;
                    grid.at(i, j+1) += 1;
                }
                catch (const std::out_of_range& oor)
                {
                }
            }
        }
    }

    return changed;
}

int main(int argc, char* argv[])
{
    const unsigned long x_dim { 200 };
    const unsigned long y_dim { 200 };

    xt::xarray<int> grid = init_grid(x_dim, y_dim);
    bool changed { true };

    iterate_grid(grid, x_dim, y_dim);

    while (changed == true)
    {
        changed = iterate_grid(grid, x_dim, y_dim);
    }
    print_grid(grid);

    return 0;
}
