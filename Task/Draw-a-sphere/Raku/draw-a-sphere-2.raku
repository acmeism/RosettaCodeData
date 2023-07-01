use Cairo;

given Cairo::Image.create(Cairo::FORMAT_ARGB32, 256, 256) {
    given Cairo::Context.new($_) {

        my Cairo::Pattern::Solid $bg .= create(.5,.5,.5);
        .rectangle(0, 0, 256, 256);
        .pattern($bg);
        .fill;
        $bg.destroy;

        my Cairo::Pattern::Gradient::Radial $shadow .=
           create(105.2, 102.4, 15.6, 102.4,  102.4, 128.0);
        $shadow.add_color_stop_rgba(0, .3, .3, .3, .3);
        $shadow.add_color_stop_rgba(1, .1, .1, .1, .02);
        .pattern($shadow);
        .arc(136.0, 134.0, 110, 0, 2 * pi);
        .fill;
        $shadow.destroy;

        my Cairo::Pattern::Gradient::Radial $sphere .=
           create(115.2, 102.4, 25.6, 102.4,  102.4, 128.0);
        $sphere.add_color_stop_rgba(0, 1, 1, .698, 1);
        $sphere.add_color_stop_rgba(1, .923, .669, .144, 1);
        .pattern($sphere);
        .arc(128.0, 128.0, 110, 0, 2 * pi);
        .fill;
        $sphere.destroy;
    };
    .write_png('sphere2-perl6.png');
}
