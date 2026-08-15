defmodule GitMailmap do
  @moduledoc """
  Parses, resolves, and serializes Git `.mailmap` entries.

  The module operates on strings and does not perform file or Git repository
  access.

  ## Examples

      iex> entries = GitMailmap.parse("Proper Name <proper@example.com> <old@example.com>\\n")
      iex> GitMailmap.resolve(entries, "Old Name", "old@example.com")
      %{name: "Proper Name", email: "proper@example.com"}
      iex> GitMailmap.serialize(entries)
      "Proper Name <proper@example.com> <old@example.com>\\n"
  """

  alias GitMailmap.{Parser, Resolver, Serializer}

  @typedoc "A parsed `.mailmap` entry."
  @type entry :: %{
          new_name: String.t() | nil,
          new_email: String.t() | nil,
          old_email: String.t(),
          old_name: String.t() | nil
        }

  @typedoc "A Git author or committer identity."
  @type identity :: %{name: String.t() | nil, email: String.t()}

  @doc """
  Parses `.mailmap` content into entries in file order.

  Invalid lines are silently ignored, matching Git.
  """
  @spec parse(String.t()) :: [entry()]
  defdelegate parse(content), to: Parser

  @doc """
  Resolves an identity through parsed mailmap entries.

  A matching name-specific entry takes priority over a general email entry.
  """
  @spec resolve([entry()], String.t() | nil, String.t()) :: identity()
  defdelegate resolve(entries, name, email), to: Resolver

  @doc """
  Serializes entries to canonical `.mailmap` lines.

  Raises `ArgumentError` when an entry cannot be represented by the format.
  """
  @spec serialize([entry()]) :: String.t()
  defdelegate serialize(entries), to: Serializer
end
