use GTK::Simple;
use GTK::Simple::App;

my GTK::Simple::App $app .= new;
$app.border-width = 20;
$app.set-content( GTK::Simple::Label.new(text => "Goodbye, World!") );
$app.run;
