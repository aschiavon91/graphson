defmodule Graphson.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphson,
      version: "0.1.1",
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Graphson",
      source_url: "https://github.com/aschiavon91/graphson"
    ]
  end

  defp description do
    """
    A simple (and **incomplete**) Graphson decoder.
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "graphson",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md),
      maintainers: ["Antonio Schiavon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aschiavon91/graphson"}
    ]
  end
end
