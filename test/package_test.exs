defmodule GitMailmap.PackageTest do
  use ExUnit.Case, async: true

  test "published package excludes third-party research notices" do
    project = Mix.Project.config()

    refute "THIRD_PARTY_NOTICES.md" in project[:package][:files]
    refute "THIRD_PARTY_NOTICES.md" in project[:docs][:extras]
    refute File.read!("README.md") =~ "THIRD_PARTY_NOTICES.md"
  end
end
