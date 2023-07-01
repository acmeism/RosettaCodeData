NB. Text that follows 'NB.' has no effect on execution.

'Character strings in J may have their value be ignored and treated as comment text.'

0 : 0
Multi-line comments may be placed in strings,
like this.
)

Note 'example'
Another way to record multi-line comments as text is to use 'Note', which is actually
a simple program that makes it clearer when defined text is used only to provide comment.
)

{{)n
  J release 9's nestable blocks can be used as comments.

  Typically, this would be in contexts where the blocks would not be used.
  That said, "literate coding practices" may stretch the boundaries here.

  Also, noun blocks (beginning with ')n') avoid syntactic concerns about content.

  These blocks even allow contained '}}' sequences to be ignored (unless, of
  course the }} character pair appears at the beginning of a line).
}}
