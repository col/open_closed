use Mix.Config

config :open_closed, :ai,
  inputs: ["CC", "CO", "OC", "OO"],
  predictions: ["1", "2", "3", "4"]

import_config "#{Mix.env()}.exs"
