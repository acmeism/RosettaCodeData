use iced::{ // 0.2.0
    button, Button, Column, Element, Length,
    Text, Sandbox, Settings, Space,
};

#[derive(Debug, Copy, Clone)]
struct Pressed;
struct Simple {
    value: i32,
    button: button::State,
}

impl Sandbox for Simple {
    type Message = Pressed;

    fn new() -> Simple {
        Simple {
            value: 0,
            button: button::State::new(),
        }
    }

    fn title(&self) -> String {
        "Simple Windowed Application".into()
    }

    fn view(&mut self) -> Element<Self::Message> {
        Column::new()
            .padding(20)
            .push({
                let text = match self.value {
                    0 => "there have been no clicks yet".into(),
                    1 => "there has been 1 click".into(),
                    n => format!("there have been {} clicks", n),
                };
                Text::new(text).size(24)
            }).push(
                Space::with_height(Length::Fill)
            ).push(
                Button::new(&mut self.button, Text::new("Click Me!"))
                    .on_press(Pressed)
            ).into()
    }

    fn update(&mut self, _: Self::Message) {
        self.value += 1;
    }
}

fn main() {
    let mut settings = Settings::default();
    settings.window.size = (600, 400);
    Simple::run(settings).unwrap();
}
