defmodule PorterStemmer.Mixfile do
  use Mix.Project

  def project do
    [ app: :porterstemmer,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      description: description,
      package: package,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Paul Sutcliffe"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/frpaulas/porterstemmer.git"}
    ]
  end

  defp description do
    """
     Porter stemmer in Elixir. It does not stem words beginning with an uppercase letter. This is to prevent stemming of acronyms or names.
    """
  end
end
