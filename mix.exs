defmodule SiftEx.Mixfile do
  use Mix.Project

  def project do
    [app: :sift_ex,
     version: "0.1.0",
     elixir: "~> 1.3",
     name: "SiftEx",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps,
     source_url: "https://github.com/C404/sift_ex"]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    SiftScience API Library for Elixir
    """
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"},
    {:poison, "~> 1.5 or ~> 2.0"},
    {:exvcr, "~> 0.6", only: :test},
    {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [files: ~w(lib mix.exs README.md LICENSE VERSION),
     maintainers: ["C404"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/C404/sift_ex"}]
  end
end
