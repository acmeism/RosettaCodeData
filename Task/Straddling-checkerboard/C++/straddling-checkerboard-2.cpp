int main()
{
  StraddlingCheckerboard sc("HOLMESRTABCDFGIJKNPQUVWXYZ./", 3, 7);

  string original = "One night-it was on the twentieth of March, 1888-I was returning";
  string en = sc.encode(original);
  string de = sc.decode(en);

  cout << "Original: " << original << endl;
  cout << "Encoded:  " << en << endl;
  cout << "Decoded:  " << de << endl;

  return 0;
}
