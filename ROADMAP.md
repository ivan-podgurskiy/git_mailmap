# Roadmap

`git_mailmap` 1.0 provides the stable string-based `parse/1`, `resolve/3`, and
`serialize/1` API.

## 1.x priorities

- Expand differential and conformance testing against Git.
- Benchmark parsing and resolution with large real-world mailmaps.
- Track future Git mailmap behavior without adding runtime dependencies.
- Maintain compatibility across supported Elixir and OTP releases.

## Deferred integrations

File I/O, Git configuration and blob lookup, CLI tooling, mailmap generation,
and Git-library integrations remain outside the core package. They may be
provided as separate packages if there is demand.

Priorities are ordered by compatibility and user feedback; no dates are
promised.
