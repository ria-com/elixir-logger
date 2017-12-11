defmodule Ria.Logger.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ria_logger,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
    ]
  end

  def application do
    [extra_applications: [],
      applications: [
        :ria_request
      ]
    ]
  end

  defp deps do
    [
      {:ria_request, git: "https://github.com/ria-com/elixir-request.git"}
    ]
  end
end
