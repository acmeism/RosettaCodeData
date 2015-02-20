std::copy(container.begin(), container.end(),
          std::ostream_iterator<container_type::value_type>(std::cout, "\n"));
