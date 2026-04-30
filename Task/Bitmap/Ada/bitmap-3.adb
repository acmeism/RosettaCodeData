use Bitmap_Store;  with Bitmap_Store;
   ...
   X : Image (1..64, 1..64);
begin
   Fill (X, (255, 255, 255));
   X (1, 2) := (R => 255, others => 0);
   X (3, 4) := X (1, 2);
