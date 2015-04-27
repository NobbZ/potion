defmodule Potion.Mixfile do
  use Mix.Project

  def project do
    [app: :potion,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [espec: :test],
     deps: deps,
     escript: escript]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:ex_parsec, "~> 0.2.1"},

     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc,  "~> 0.7", only: :dev},

     {:espec, "~> 0.5.0", only: :test},

     {:inch_ex, only: :docs}]
  end

  defp escript do
    [main_module: Potion]
  end
end
