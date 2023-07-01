try {
  foo();
}
catch (MyException &exc)
{
  // handle exceptions of type MyException and derived
}
catch (std::exception &exc)
{
  // handle exceptions derived from std::exception, which were not handled by above catches
  // e.g.
  std::cerr << exc.what() << std::endl;
}
catch (...)
{
  // handle any type of exception not handled by above catches
}
