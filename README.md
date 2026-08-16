# GitMailmap

Parse, resolve, and serialize Git `.mailmap` files in pure Elixir. The package
supports Elixir 1.14 or newer and has no runtime dependencies.

## Installation

Add `git_mailmap` to your dependencies:

```elixir
def deps do
  [
    {:git_mailmap, "~> 1.0"}
  ]
end
```

## Usage

```elixir
entries =
  GitMailmap.parse("""
  Joe R. Developer <joe@example.com>
  Jane Doe <jane@example.com> <jane@desktop.(none)>
  """)

GitMailmap.resolve(entries, "Jane D.", "jane@desktop.(none)")
#=> %{name: "Jane Doe", email: "jane@example.com"}

GitMailmap.serialize(entries)
#=> "Joe R. Developer <joe@example.com>\n..."
```

## Entry format

`GitMailmap.parse/1` returns a list of entry maps:

```elixir
%{
  new_name: String.t() | nil,
  new_email: String.t() | nil,
  old_email: String.t(),
  old_name: String.t() | nil
}
```

The parser accepts the Git-compatible forms below:

```text
Proper Name <commit@email>
<proper@email> <commit@email>
Proper Name <proper@email> <commit@email>
Proper Name <proper@email> Commit Name <commit@email>
<proper@email> Commit Name <commit@email>
```

Only a `#` in the first column starts a comment. Matching of names and emails
uses ASCII case-insensitive comparison, as Git does.

## API

### `GitMailmap.parse/1`

Parses `.mailmap` content into entries in file order. Invalid lines are
silently ignored, matching Git. Emails used for matching are normalized to
lowercase ASCII.

### `GitMailmap.resolve/3`

Returns the canonical `%{name: name, email: email}` identity. Email and name
matching use ASCII case-insensitive comparison. A matching name-and-email
entry takes priority over a general email entry. Repeated general entries
update only the fields they specify, matching Git's cumulative behavior.

### `GitMailmap.serialize/1`

Serializes entries to canonical `.mailmap` lines with a trailing newline.
Programmatically constructed entries that cannot be represented in the format
raise `ArgumentError`.

## Scope

The package handles strings only. Reading `.mailmap` files, Git configuration,
Git blobs, and command-line integration are intentionally left to consumers.

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for planned compatibility, testing, and
performance work.

## License

MIT.
