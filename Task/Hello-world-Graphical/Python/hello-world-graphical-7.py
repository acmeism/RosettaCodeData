from kivy.app import App
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.button import Button
from kivy.uix.popup import Popup
from kivy.uix.label import Label


class GoodByeApp(App):
    def build(self, *args, **kwargs):
        layout = FloatLayout()
        ppp = Popup(title='Goodbye, World!',
                    size_hint=(0.75, 0.75), opacity=0.8,
                    content=Label(font_size='50sp', text='Goodbye, World!'))
        btn = Button(text='Goodbye', size_hint=(0.3, 0.3),
                     pos_hint={'center': (0.5, 0.5)}, on_press=ppp.open)
        layout.add_widget(btn)
        return layout


GoodByeApp().run()
