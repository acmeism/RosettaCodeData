#include <windows.h>
#include <vector>
#include <string>

using namespace std;

//////////////////////////////////////////////////////
struct Point {
  int x, y;
};

//////////////////////////////////////////////////////
class MyBitmap {
 public:
  MyBitmap() : pen_(nullptr) {}
  ~MyBitmap() {
    DeleteObject(pen_);
    DeleteDC(hdc_);
    DeleteObject(bmp_);
  }

  bool Create(int w, int h) {
    BITMAPINFO	bi;
    ZeroMemory(&bi, sizeof(bi));

    bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
    bi.bmiHeader.biBitCount = sizeof(DWORD) * 8;
    bi.bmiHeader.biCompression = BI_RGB;
    bi.bmiHeader.biPlanes = 1;
    bi.bmiHeader.biWidth = w;
    bi.bmiHeader.biHeight = -h;

    void *bits_ptr = nullptr;
    HDC dc = GetDC(GetConsoleWindow());
    bmp_ = CreateDIBSection(dc, &bi, DIB_RGB_COLORS, &bits_ptr, nullptr, 0);
    if (!bmp_) return false;

    hdc_ = CreateCompatibleDC(dc);
    SelectObject(hdc_, bmp_);
    ReleaseDC(GetConsoleWindow(), dc);

    width_ = w;
    height_ = h;

    return true;
  }

  void SetPenColor(DWORD clr) {
    if (pen_) DeleteObject(pen_);
    pen_ = CreatePen(PS_SOLID, 1, clr);
    SelectObject(hdc_, pen_);
  }

  bool SaveBitmap(const char* path) {
    HANDLE file = CreateFile(path, GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (file == INVALID_HANDLE_VALUE) {
      return false;
    }

    BITMAPFILEHEADER fileheader;
    BITMAPINFO infoheader;
    BITMAP bitmap;
    GetObject(bmp_, sizeof(bitmap), &bitmap);

    DWORD* dwp_bits = new DWORD[bitmap.bmWidth * bitmap.bmHeight];
    ZeroMemory(dwp_bits, bitmap.bmWidth * bitmap.bmHeight * sizeof(DWORD));
    ZeroMemory(&infoheader, sizeof(BITMAPINFO));
    ZeroMemory(&fileheader, sizeof(BITMAPFILEHEADER));

    infoheader.bmiHeader.biBitCount = sizeof(DWORD) * 8;
    infoheader.bmiHeader.biCompression = BI_RGB;
    infoheader.bmiHeader.biPlanes = 1;
    infoheader.bmiHeader.biSize = sizeof(infoheader.bmiHeader);
    infoheader.bmiHeader.biHeight = bitmap.bmHeight;
    infoheader.bmiHeader.biWidth = bitmap.bmWidth;
    infoheader.bmiHeader.biSizeImage = bitmap.bmWidth * bitmap.bmHeight * sizeof(DWORD);

    fileheader.bfType = 0x4D42;
    fileheader.bfOffBits = sizeof(infoheader.bmiHeader) + sizeof(BITMAPFILEHEADER);
    fileheader.bfSize = fileheader.bfOffBits + infoheader.bmiHeader.biSizeImage;

    GetDIBits(hdc_, bmp_, 0, height_, (LPVOID)dwp_bits, &infoheader, DIB_RGB_COLORS);

    DWORD wb;
    WriteFile(file, &fileheader, sizeof(BITMAPFILEHEADER), &wb, nullptr);
    WriteFile(file, &infoheader.bmiHeader, sizeof(infoheader.bmiHeader), &wb, nullptr);
    WriteFile(file, dwp_bits, bitmap.bmWidth * bitmap.bmHeight * 4, &wb, nullptr);
    CloseHandle(file);

    delete[] dwp_bits;
    return true;
  }

  HDC hdc() { return hdc_; }
  int width() { return width_; }
  int height() { return height_; }

 private:
  HBITMAP bmp_;
  HDC hdc_;
  HPEN pen_;
  int width_, height_;
};

static int DistanceSqrd(const Point& point, int x, int y) {
  int xd = x - point.x;
  int yd = y - point.y;
  return (xd * xd) + (yd * yd);
}

//////////////////////////////////////////////////////
class Voronoi {
 public:
  void Make(MyBitmap* bmp, int count) {
    bmp_ = bmp;
    CreatePoints(count);
    CreateColors();
    CreateSites();
    SetSitesPoints();
  }

 private:
  void CreateSites() {
    int w = bmp_->width(), h = bmp_->height(), d;
    for (int hh = 0; hh < h; hh++) {
      for (int ww = 0; ww < w; ww++) {
        int ind = -1, dist = INT_MAX;
        for (size_t it = 0; it < points_.size(); it++) {
          const Point& p = points_[it];
          d = DistanceSqrd(p, ww, hh);
          if (d < dist) {
            dist = d;
            ind = it;
          }
        }

        if (ind > -1)
          SetPixel(bmp_->hdc(), ww, hh, colors_[ind]);
        else
          __asm nop // should never happen!
        }
    }
  }

  void SetSitesPoints() {
    for (const auto& point : points_) {
      int x = point.x, y = point.y;
      for (int i = -1; i < 2; i++)
        for (int j = -1; j < 2; j++)
          SetPixel(bmp_->hdc(), x + i, y + j, 0);
    }
  }

  void CreatePoints(int count) {
    const int w = bmp_->width() - 20, h = bmp_->height() - 20;
    for (int i = 0; i < count; i++) {
      points_.push_back({ rand() % w + 10, rand() % h + 10 });
    }
  }

  void CreateColors() {
    for (size_t i = 0; i < points_.size(); i++) {
      DWORD c = RGB(rand() % 200 + 50, rand() % 200 + 55, rand() % 200 + 50);
      colors_.push_back(c);
    }
  }

  vector<Point> points_;
  vector<DWORD> colors_;
  MyBitmap* bmp_;
};

//////////////////////////////////////////////////////
int main(int argc, char* argv[]) {
  ShowWindow(GetConsoleWindow(), SW_MAXIMIZE);
  srand(GetTickCount());

  MyBitmap bmp;
  bmp.Create(512, 512);
  bmp.SetPenColor(0);

  Voronoi v;
  v.Make(&bmp, 50);

  BitBlt(GetDC(GetConsoleWindow()), 20, 20, 512, 512, bmp.hdc(), 0, 0, SRCCOPY);
  bmp.SaveBitmap("v.bmp");

  system("pause");

  return 0;
}
