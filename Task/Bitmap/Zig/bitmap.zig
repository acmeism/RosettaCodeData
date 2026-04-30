const std = @import("std");

pub const Rgb = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const PixelOutOfBounds = error{PixelOutOfBounds};

pub const Bitmap = struct {
    width: usize,
   height: usize,
   pixels: []Rgb,

   // The ! next to the return type communicates that the function may return an error
   pub fn new(allocator: std.mem.Allocator, width: usize, height: usize) !Bitmap {
       // In Zig libraries that allocate receive an allocator
      // instead of choosing one themselves
       var pixels = try allocator.alloc(Rgb, width * height);

      for (0..width*height) | i | {
          pixels[i] = Rgb { .r = 0, .g = 0, .b = 0 };
      }

       return Bitmap {
          .width = width,
         .height = height,
         .pixels = pixels,
      };
   }

   pub fn free(self: Bitmap, allocator: std.mem.Allocator) void {
      allocator.free(self.pixels);
   }

   pub fn fill(self: *Bitmap, color: Rgb) void {
       for (0..self.width*self.height) | i | {
          self.pixels[i] = color;
      }
   }

   pub fn get_pixel_unchecked(self: Bitmap, x: usize, y: usize) Rgb {
       return self.pixels[self.height * y + x];
   }

   pub fn get_pixel(self: Bitmap, x: usize, y: usize) !Rgb {
       if (self.width <= x or self.height <= y) {
          return error.PixelOutOfBounds;
      }

      return self.get_pixel_unchecked(x, y);
   }

   pub fn set_pixel_unchecked(self: *Bitmap, x: usize, y: usize, color: Rgb) void {
       self.pixels[self.height * y + x] = color;
   }

   pub fn set_pixel(self: *Bitmap, x: usize, y: usize, color: Rgb) !void {
       if (self.width <= x or self.height <= y) {
          return error.PixelOutOfBounds;
      }

      return self.set_pixel_unchecked(x, y, color);
   }
};

test "putting a pixel gets the pixel" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
   const allocator = gpa.allocator();

   var bm = try Bitmap.new(allocator, 10, 10);
   defer bm.free(allocator);

   try bm.set_pixel(4, 4, Rgb {.r=255, .g=0, .b=0});

   const pixel = try bm.get_pixel(4, 4);

   try std.testing.expectEqual(255, pixel.r);
}

test "filling a pixel gets all the pixels" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
   const allocator = gpa.allocator();

   var bm = try Bitmap.new(allocator, 10, 10);
   defer bm.free(allocator);

   bm.fill(Rgb {.r=255, .g=0, .b=0});

   for (0..10) | x | {
       for (0..10) | y | {
          try std.testing.expectEqual(255, bm.get_pixel_unchecked(x, y).r);
      }
   }
}
