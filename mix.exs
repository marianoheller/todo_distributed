defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:gproc, :cowboy, :plug],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:gproc, "~> 0.8.0"},
      {:plug_cowboy, "~> 2.1"},
      {:plug, "~> 1.9"},
      {:meck, "~> 0.8.13", only: :test},
      {:httpoison, "~> 1.6", only: :test}
    ]
  end
end
