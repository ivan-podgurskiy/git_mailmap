defmodule GitMailmap.Resolver do
  @moduledoc false

  @spec resolve([GitMailmap.entry()], String.t() | nil, String.t()) :: GitMailmap.identity()
  def resolve(entries, name, email) when is_list(entries) and is_binary(email) do
    matches =
      Enum.reduce(entries, initial_matches(), fn entry, matches ->
        collect_match(entry, matches, name, email)
      end)

    apply_match(matches, name, email)
  end

  defp initial_matches do
    %{specific: nil, general_name: nil, general_email: nil, has_general: false}
  end

  defp collect_match(entry, matches, name, email) do
    if ascii_equal?(entry.old_email, email) do
      collect_email_match(entry, matches, name)
    else
      matches
    end
  end

  defp collect_email_match(%{old_name: nil} = entry, matches, _name) do
    %{
      matches
      | general_name: entry.new_name || matches.general_name,
        general_email: entry.new_email || matches.general_email,
        has_general: true
    }
  end

  defp collect_email_match(%{old_name: old_name} = entry, matches, name)
       when not is_nil(name) do
    if ascii_equal?(old_name, name), do: %{matches | specific: entry}, else: matches
  end

  defp collect_email_match(_entry, matches, _name), do: matches

  defp apply_match(%{specific: entry}, name, email) when not is_nil(entry) do
    %{name: entry.new_name || name, email: entry.new_email || email}
  end

  defp apply_match(%{has_general: true} = matches, name, email) do
    %{name: matches.general_name || name, email: matches.general_email || email}
  end

  defp apply_match(_matches, name, email), do: %{name: name, email: email}

  defp ascii_equal?(left, right), do: ascii_lower(left) == ascii_lower(right)

  defp ascii_lower(value) do
    for <<byte <- value>>, into: <<>> do
      if byte in ?A..?Z, do: <<byte + 32>>, else: <<byte>>
    end
  end
end
