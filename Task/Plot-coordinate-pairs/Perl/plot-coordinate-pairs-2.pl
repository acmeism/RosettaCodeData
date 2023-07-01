use Imager;
use Imager::Plot;

@x = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
@y = (2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0);
$plot = Imager::Plot->new(
  Width => 400,
  Height => 300,
  GlobalFont => 'PATH_TO_TTF_FONT',
);
$plot->AddDataSet(
  X => \@x,
  Y => \@y,
  style => {
    marker => {
      size => 2,
      symbol => 'circle',
      color => Imager::Color->new('red'),
    },
  },
);
$img = Imager->new(
  xsize => 500,
  ysize => 400,
);
$img->box(filled => 1, color => 'white');
$plot->Render(Image => $img, Xoff => 50, Yoff => 350);
$img->write(file => 'qsort-range-10-9.png');
