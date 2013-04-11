std::copy(container.begin(), container.end(),
          std::output_iterator<container_type::value_type>(std::cout, "\n"));
