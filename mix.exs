defmodule GitMailmap.MixProject do
  use Mix.Project

  @version "1.0.1"
  @source_url "https://github.com/ivan-podgurskiy/git_mailmap"

  def project do
    [
      app: :git_mailmap,
      version: @version,
      elixir: "~> 1.14",
      deps: deps(),
      name: "GitMailmap",
      description:
        "Parse, resolve, and serialize Git .mailmap files in Elixir to canonicalize author and committer identities.",
      package: package(),
      source_url: @source_url,
      docs: docs(),
      test_coverage: [summary: [threshold: 100]],
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        plt_local_path: "priv/plts/local.plt",
        plt_core_path: "priv/plts/core.plt"
      ]
    ]
  end

  defp deps do
    [
      {:stream_data, "~> 1.1", only: [:dev, :test]},
      {:jason, "~> 1.4", only: [:dev, :test]},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md ROADMAP.md),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      maintainers: ["Ivan Podgurskiy"]
    ]
  end

  defp docs do
    [
      main: "GitMailmap",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "ROADMAP.md", "LICENSE"]
    ]
  end
end
