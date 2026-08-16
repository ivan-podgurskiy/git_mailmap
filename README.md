# GitMailmap — Git `.mailmap` for Elixir

[![CI](https://github.com/ivan-podgurskiy/git_mailmap/actions/workflows/ci.yml/badge.svg)](https://github.com/ivan-podgurskiy/git_mailmap/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/git_mailmap.svg)](https://hex.pm/packages/git_mailmap)
[![HexDocs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/git_mailmap)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

GitMailmap is a pure Elixir parser, identity resolver, and serializer for Git
`.mailmap` files. A mailmap maps historical contributor names and email
addresses to canonical author and committer identities, so aliases are treated
as the same person.

Use GitMailmap when an Elixir application needs to process those mappings
without invoking Git or reading a repository. The package works on strings,
supports Elixir 1.14 or newer, and has no runtime dependencies.

## Features

- Parse the five Git `.mailmap` entry forms into ordered Elixir maps.
- Resolve author or committer aliases with Git-compatible matching and
  precedence.
- Serialize parsed or programmatically constructed entries to canonical
  `.mailmap` lines.
- Handle comments, invalid lines, repeated mappings, and ASCII
  case-insensitive names and emails like Git.
- Run as a small, pure Elixir library with no filesystem, network, or Git
  process access.

## Installation

Add `git_mailmap` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:git_mailmap, "~> 1.0"}
  ]
end
```

## Quick start

Parse mailmap content, resolve an alias, and serialize the mappings again:

```elixir
entries =
  GitMailmap.parse("""
  Joe R. Developer <joe@example.com>
  Jane Doe <jane@example.com> <jane@desktop.(none)>
  """)

GitMailmap.resolve(entries, "Jane D.", "jane@desktop.(none)")
#=> %{name: "Jane Doe", email: "jane@example.com"}

GitMailmap.serialize(entries)
#=> "Joe R. Developer <joe@example.com>\nJane Doe <jane@example.com> <jane@desktop.(none)>\n"
```

## Mailmap entry format

`GitMailmap.parse/1` returns entries in file order:

```elixir
%{
  new_name: String.t() | nil,
  new_email: String.t() | nil,
  old_email: String.t(),
  old_name: String.t() | nil
}
```

The parser accepts all five Git-compatible forms:

```text
Proper Name <commit@email>
<proper@email> <commit@email>
Proper Name <proper@email> <commit@email>
Proper Name <proper@email> Commit Name <commit@email>
<proper@email> Commit Name <commit@email>
```

A `#` starts a comment only in the first column. Invalid lines are silently
ignored, matching Git. Emails stored for matching are normalized to lowercase
ASCII.

## Identity resolution

`GitMailmap.resolve/3` takes parsed entries plus a contributor name and email,
then returns the canonical `%{name: name, email: email}` identity.

- Names and emails are compared using ASCII case-insensitive matching.
- A matching name-and-email entry takes priority over a general email entry.
- Repeated general entries update only the fields they specify, matching Git's
  cumulative behavior.
- When no entry matches, the input name and email are returned unchanged.

## Use cases

- Canonicalize contributor identities before generating credits, reports, or
  repository analytics.
- Reconcile historical names and email addresses while importing Git commit
  metadata into an Elixir application.
- Apply mailmap content supplied by a repository host or Git client without
  shelling out to `git check-mailmap`.
- Parse, transform, and serialize generated `.mailmap` mappings in release or
  developer tooling.

## API

### `GitMailmap.parse/1`

Parses `.mailmap` content into entries in file order. Invalid lines are
silently ignored.

### `GitMailmap.resolve/3`

Resolves a name and email through parsed entries and returns their canonical
identity.

### `GitMailmap.serialize/1`

Serializes entries to canonical `.mailmap` lines with a trailing newline.
Programmatically constructed entries that cannot be represented in the format
raise `ArgumentError`.

See the complete API documentation on
[HexDocs](https://hexdocs.pm/git_mailmap/GitMailmap.html).

## Compatibility and scope

GitMailmap implements the string-based parsing, matching, precedence, and
serialization behavior documented above. Compatibility is covered by example,
integration, property, and shared cross-implementation test vectors.

The package does not read `.mailmap` files, inspect Git configuration, load Git
blobs, discover repositories, or provide a command-line interface. File I/O,
repository access, and Git integration remain the caller's responsibility.

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for planned compatibility, testing, and
performance work.

## License

MIT.
