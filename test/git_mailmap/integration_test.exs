defmodule GitMailmap.IntegrationTest do
  use ExUnit.Case, async: true

  test "resolves the gitmailmap(5) examples" do
    entries =
      GitMailmap.parse("""
      Joe R. Developer <joe@example.com>
      Jane Doe <jane@example.com> <jane@laptop.(none)>
      Jane Doe <jane@example.com> <jane@desktop.(none)>
      """)

    assert GitMailmap.resolve(entries, "Jane D.", "jane@desktop.(none)") == %{
             name: "Jane Doe",
             email: "jane@example.com"
           }

    assert GitMailmap.resolve(entries, "Joe Developer", "joe@example.com") == %{
             name: "Joe R. Developer",
             email: "joe@example.com"
           }
  end

  test "parsed entries round-trip through serialization" do
    for vector <- conformance()["parse"] do
      entries = GitMailmap.parse(vector["input"])

      assert entries |> GitMailmap.serialize() |> GitMailmap.parse() == entries,
             "failed conformance vector: #{vector["name"]}"
    end
  end

  defp conformance do
    "test/fixtures/conformance.json"
    |> File.read!()
    |> Jason.decode!()
  end
end
