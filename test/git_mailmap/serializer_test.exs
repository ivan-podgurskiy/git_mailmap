defmodule GitMailmap.SerializerTest do
  use ExUnit.Case, async: true

  test "matches the shared serialization vectors" do
    for vector <- conformance()["serialize"] do
      entries = Enum.map(vector["entries"], &atomize_entry/1)

      assert GitMailmap.serialize(entries) == vector["output"],
             "failed conformance vector: #{vector["name"]}"
    end
  end

  test "rejects an entry that changes nothing" do
    entry = %{new_name: nil, new_email: nil, old_email: "old@email", old_name: nil}

    assert_raise ArgumentError, fn -> GitMailmap.serialize([entry]) end
  end

  test "rejects a name-specific entry without a canonical email" do
    entry = %{
      new_name: "Canonical",
      new_email: nil,
      old_email: "old@email",
      old_name: "Old Name"
    }

    assert_raise ArgumentError, fn -> GitMailmap.serialize([entry]) end
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
