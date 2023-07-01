lower: procedure;  parse arg a;   @= 'abcdefghijklmnopqrstuvwxyz';    @u= @;    upper @u
                   return translate(a, @, @u)
