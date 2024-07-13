function Wrap(words: sequence of string; lineWidth: integer): sequence of string;
begin
  var currentWidth := 0;
  foreach var word in words do
  begin
    if currentWidth <> 0 then
      if currentWidth + word.Length < lineWidth then
      begin
        currentWidth += 1;
        yield ' ';
      end
      else
      begin
        currentWidth := 0;
        yield NewLine;
      end;
    currentWidth += word.Length;
    yield word;
  end;
end;

function Wrap(text: string; lineWidth: integer): string
  := Wrap(text.ToWords(' '#13#10),lineWidth).JoinToString('');

begin
  var text := '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas varius sapien
vel purus hendrerit vehicula. Integer hendrerit viverra turpis, ac sagittis arcu
pharetra id. Sed dapibus enim non dui posuere sit amet rhoncus tellus
consectetur. Proin blandit lacus vitae nibh tincidunt cursus. Cum sociis natoque
penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam tincidunt
purus at tortor tincidunt et aliquam dui gravida. Nulla consectetur sem vel
felis vulputate et imperdiet orci pharetra. Nam vel tortor nisi. Sed eget porta
tortor. Aliquam suscipit lacus vel odio faucibus tempor. Sed ipsum est,
condimentum eget eleifend ac, ultricies non dui. Integer tempus, nunc sed
venenatis feugiat, augue orci pellentesque risus, nec pretium lacus enim eu
nibh.
''';
  Wrap(text,50).Println;
end.
