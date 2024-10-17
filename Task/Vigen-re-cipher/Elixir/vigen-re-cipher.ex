defmodule VigenereCipher do
  @base  ?A
  @size  ?Z - @base + 1

  def encrypt(text, key), do: crypt(text, key, 1)

  def decrypt(text, key), do: crypt(text, key, -1)

  defp crypt(text, key, dir) do
    text = String.upcase(text) |> String.replace(~r/[^A-Z]/, "") |> to_char_list
    key_iterator = String.upcase(key) |> String.replace(~r/[^A-Z]/, "") |> to_char_list
                   |> Enum.map(fn c -> (c - @base) * dir end) |> Stream.cycle
    Enum.zip(text, key_iterator)
    |> Enum.reduce('', fn {char, offset}, ciphertext ->
         [rem(char - @base + offset + @size, @size) + @base | ciphertext]
       end)
    |> Enum.reverse |> List.to_string
  end
end

plaintext = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
key = "Vigenere cipher"
ciphertext = VigenereCipher.encrypt(plaintext, key)
recovered  = VigenereCipher.decrypt(ciphertext, key)

IO.puts "Original: #{plaintext}"
IO.puts "Encrypted: #{ciphertext}"
IO.puts "Decrypted: #{recovered}"
