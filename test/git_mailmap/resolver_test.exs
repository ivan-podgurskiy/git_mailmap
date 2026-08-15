defmodule GitMailmap.ResolverTest do
  use ExUnit.Case, async: true

  test "matches the shared resolution vectors" do
    for vector <- conformance()["resolve"] do
      entries = GitMailmap.parse(vector["mailmap"])
      input = vector["input"]

      assert GitMailmap.resolve(entries, input["name"], input["email"]) ==
               atomize_identity(vector["identity"]),
             "failed conformance vector: #{vector["name"]}"
    end
  end

  defp conformance do
    "test/fixtures/conformance.json"
    |> File.read!()
    |> Jason.decode!()
  end

  defp atomize_identity(identity) do
    %{name: identity["name"], email: identity["email"]}
  end
end
