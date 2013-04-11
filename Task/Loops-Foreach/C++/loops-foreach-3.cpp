void print_element(container_type::value_type const& v)
{
  std::cout << v << "\n";
}

...
  std::for_each(container.begin(), container.end(), print_element);
