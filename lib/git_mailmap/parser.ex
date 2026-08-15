defmodule GitMailmap.Parser do
  @moduledoc false

  @spec parse(String.t()) :: [GitMailmap.entry()]
  def parse(content) when is_binary(content) do
    content
    |> String.split("\n", trim: false)
    |> Enum.reduce([], &parse_line/2)
    |> Enum.reverse()
  end

  defp parse_line("#" <> _comment, entries), do: entries

  defp parse_line(line, entries) do
    case parse_identity(line, false) do
      nil ->
        entries

      {name1, email1, rest} ->
        build_entry(parse_identity(rest, true), name1, email1, entries)
    end
  end

  defp build_entry({name2, email2, _rest}, name1, email1, entries) do
    [
      %{
        new_name: name1,
        new_email: email1,
        old_email: ascii_lower(email2),
        old_name: name2
      }
      | entries
    ]
  end

  defp build_entry(nil, name1, email1, entries) when not is_nil(name1) do
    [
      %{
        new_name: name1,
        new_email: nil,
        old_email: ascii_lower(email1),
        old_name: nil
      }
      | entries
    ]
  end

  defp build_entry(nil, _name1, _email1, entries), do: entries

  defp parse_identity(input, allow_empty_email?) do
    with {left, 1} <- :binary.match(input, "<"),
         tail <- binary_part(input, left + 1, byte_size(input) - left - 1),
         {right, 1} <- :binary.match(tail, ">"),
         email <- binary_part(tail, 0, right),
         true <- allow_empty_email? or email != "" do
      name =
        input
        |> binary_part(0, left)
        |> String.trim()
        |> present()

      rest_offset = left + right + 2
      rest = binary_part(input, rest_offset, byte_size(input) - rest_offset)
      {name, email, rest}
    else
      _error -> nil
    end
  end

  defp present(""), do: nil
  defp present(value), do: value

  defp ascii_lower(value) do
    for <<byte <- value>>, into: <<>> do
      if byte in ?A..?Z, do: <<byte + 32>>, else: <<byte>>
    end
  end
end
