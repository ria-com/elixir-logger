# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :ria_logger,
  default: :elasticsearch,
  types: %{
    elasticsearch: %{
      url: "http://elasticsearch.ria.com:80"
    }
  }
#import_config "#{Mix.env}.exs"