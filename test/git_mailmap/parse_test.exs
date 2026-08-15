defmodule GitMailmap.ParseTest do
  use ExUnit.Case, async: true

  test "matches the shared parsing vectors" do
    for vector <- conformance()["parse"] do
      expected = Enum.map(vector["entries"], &atomize_entry/1)

      assert GitMailmap.parse(vector["input"]) == expected,
             "failed conformance vector: #{vector["name"]}"
    end
  end

  defp conformance do
    "test/fixtures/conformance.json"
    |> File.read!()
    |> Jason.decode!()
  end

  defp atomize_entry(entry) do
    %{
      new_name: entry["newName"],
      new_email: entry["newEmail"],
      old_email: entry["oldEmail"],
      old_name: entry["oldName"]
    }
  end
end
