defmodule Holiday do
  @offsets  [ Easter: 0, Ascension: 39, Pentecost: 49, Trinity: 56, Corpus: 60 ]
  @mon  { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }

  def easter_date(year) do
    a = rem(year, 19)
    b = div(year, 100)
    c = rem(year, 100)
    d = div(b, 4)
    e = rem(b, 4)
    f = div((b + 8), 25)
    g = div((b - f + 1), 3)
    h = rem((19*a + b - d - g + 15), 30)
    i = div(c, 4)
    k = rem(c, 4)
    l = rem((32 + 2*e + 2*i - h - k), 7)
    m = div((a + 11*h + 22*l), 451)
    numerator = h + l - 7*m + 114
    month = div(numerator, 31)
    day = rem(numerator, 31) + 1
    {year, month, day}
  end

  defp holidays(year) do
    IO.write String.rjust("#{year}:", 5)
    gday = :calendar.date_to_gregorian_days(easter_date(year))
    Enum.map_join(Keyword.values(@offsets), fn d ->
      {_year, month, day} = :calendar.gregorian_days_to_date(gday + d)
      String.rjust("#{day}  #{elem(@mon, month-1)}", 11)
    end)
  end

  def task do
    IO.puts "Year:" <> Enum.map_join(Keyword.keys(@offsets), &String.rjust("#{&1}",11))
    Enum.each(Enum.take_every(400..2100, 100), fn year -> IO.puts holidays(year) end)
    IO.puts ""
    Enum.each(2010..2020, fn year -> IO.puts holidays(year) end)
  end
end

Holiday.task
