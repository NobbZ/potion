defmodule Potion do
	def main(_args) do
    IO.puts(inspect ExParsec.parse_value "a123", Potion.Parser.integer)
  end
end
