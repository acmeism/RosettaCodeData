defmodule Old_lady do
  @descriptions [
    fly:    "I don't know why S",
    spider: "That wriggled and jiggled and tickled inside her.",
    bird:   "Quite absurd T",
    cat:    "Fancy that, S",
    dog:    "What a hog, S",
    goat:   "She opened her throat T",
    cow:    "I don't know how S",
    horse:  "She's dead, of course.",
  ]

  def swallowed do
    {descriptions, animals} = setup(@descriptions)
    Enum.each(Enum.with_index(animals), fn {animal, idx} ->
      IO.puts "There was an old lady who swallowed a #{animal}."
      IO.puts descriptions[animal]
      if animal == :horse, do: exit(:normal)
      if idx > 0 do
        Enum.each(idx..1, fn i ->
          IO.puts "She swallowed the #{Enum.at(animals,i)} to catch the #{Enum.at(animals,i-1)}."
          case Enum.at(animals,i-1) do
            :spider -> IO.puts descriptions[:spider]
            :fly -> IO.puts descriptions[:fly]
            _ -> :ok
          end
        end)
      end
      IO.puts "Perhaps she'll die.\n"
    end)
  end

  def setup(descriptions) do
    animals = Keyword.keys(descriptions)
    descs = Enum.reduce(animals, descriptions, fn animal, acc ->
              Keyword.update!(acc, animal, fn d ->
                case String.last(d) do
                  "S" -> String.replace(d, ~r/S$/, "she swallowed a #{animal}.")
                  "T" -> String.replace(d, ~r/T$/, "to swallow a #{animal}.")
                  _   -> d
                end
              end)
            end)
    {descs, animals}
  end
end

Old_lady.swallowed
