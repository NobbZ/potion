# We are using ExUnit for doctests only

ExUnit.start()

defmodule Potion.Test do
  use ExUnit.Case, async: true

  doctest Potion
  doctest Potion.Parser
  doctest Potion.Token
end