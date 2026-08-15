defmodule GitMailmap.PropertyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  property "an empty mailmap leaves identities unchanged" do
    check all(
            name <- one_of([constant(nil), string(:printable)]),
            email <- string(:printable),
            max_runs: 200
          ) do
      assert GitMailmap.resolve([], name, email) == %{name: name, email: email}
    end
  end
end
