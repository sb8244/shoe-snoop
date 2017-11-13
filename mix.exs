defmodule ShoeSnoop.Mixfile do
  use Mix.Project

  def project do
    [app: :shoe_snoop,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      applications: app_list(Mix.env),
      extra_applications: extra_app_list(Mix.env),
      mod: {ShoeSnoop.Application, []},
    ]
  end

  defp app_list(_) do
    [:httpoison]
  end

  defp extra_app_list(_) do
    [:logger]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:floki, "~> 0.19.0"}
    ]
  end
end
