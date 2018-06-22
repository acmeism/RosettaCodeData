from kivy.app import App
from kivy.lang.builder import Builder

kv = '''
#:import Factory kivy.factory.Factory

FloatLayout:
    Button:
        text: 'Goodbye'
        size_hint: (0.3, 0.3)
        pos_hint: {'center': (0.5, 0.5)}
        on_press: Factory.ThePopUp().open()

<ThePopUp@Popup>:
    title: 'Goodbye, World!'
    size_hint: (0.75, 0.75)
    opacity: 0.8
    Label:
        text: 'Goodbye, World!'
        font_size: '50sp'
'''


class GoodByeApp(App):
    def build(self, *args, **kwargs):
        return Builder.load_string(kv)


GoodByeApp().run()
