        /// <summary>
        /// Draws a circle.
        /// </summary>
        /// <param name="image">
        /// The destination image.
        /// </param>
        /// <param name="centerX">
        /// The x center position of the circle.
        /// </param>
        /// <param name="centerY">
        /// The y center position of the circle.
        /// </param>
        /// <param name="radius">
        /// The radius of the circle.
        /// </param>
        /// <param name="color">
        /// The color to use.
        /// </param>
        public static void DrawCircle(this GenericImage image, int centerX, int centerY, int radius, Color color)
        {
            int d = (5 - radius * 4) / 4;
            int x = 0;
            int y = radius;

            do
            {
                // ensure index is in range before setting (depends on your image implementation)
                // in this case we check if the pixel location is within the bounds of the image before setting the pixel
                if (centerX + x >= 0 && centerX + x <= image.Width - 1 && centerY + y >= 0 && centerY + y <= image.Height - 1) image[centerX + x, centerY + y] = color;
                if (centerX + x >= 0 && centerX + x <= image.Width - 1 && centerY - y >= 0 && centerY - y <= image.Height - 1) image[centerX + x, centerY - y] = color;
                if (centerX - x >= 0 && centerX - x <= image.Width - 1 && centerY + y >= 0 && centerY + y <= image.Height - 1) image[centerX - x, centerY + y] = color;
                if (centerX - x >= 0 && centerX - x <= image.Width - 1 && centerY - y >= 0 && centerY - y <= image.Height - 1) image[centerX - x, centerY - y] = color;
                if (centerX + y >= 0 && centerX + y <= image.Width - 1 && centerY + x >= 0 && centerY + x <= image.Height - 1) image[centerX + y, centerY + x] = color;
                if (centerX + y >= 0 && centerX + y <= image.Width - 1 && centerY - x >= 0 && centerY - x <= image.Height - 1) image[centerX + y, centerY - x] = color;
                if (centerX - y >= 0 && centerX - y <= image.Width - 1 && centerY + x >= 0 && centerY + x <= image.Height - 1) image[centerX - y, centerY + x] = color;
                if (centerX - y >= 0 && centerX - y <= image.Width - 1 && centerY - x >= 0 && centerY - x <= image.Height - 1) image[centerX - y, centerY - x] = color;
                if (d < 0)
                {
                    d += 2 * x + 1;
                }
                else
                {
                    d += 2 * (x - y) + 1;
                    y--;
                }
                x++;
            } while (x <= y);
        }
