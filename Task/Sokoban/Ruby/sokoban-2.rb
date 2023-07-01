level = <<EOS
#######
#     #
#     #
#. #  #
#. $$ #
#.$$  #
#.#  @#
#######
EOS
puts level, "", Sokoban.new(level).solve
