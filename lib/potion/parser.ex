defmodule Potion.Parser do
  use ExParsec

  alias Potion.Token

  def evaluate(code) do
    2
  end

  @doc """
  Parses any Integral literal to an %Potion.Token{type: :int}.

  ## Examples

      iex> ExParsec.parse_value "123", Potion.Parser.integer
      {:ok, nil, %Potion.Token{type: :int, value: 123}}

      iex> ExParsec.parse_value "123a", Potion.Parser.integer
      {:ok, nil, %Potion.Token{type: :int, value: 123}}

      iex> ExParsec.parse_value "a123", Potion.Parser.integer
      {:error,
       [%ExParsec.Error{kind: :expected_char,
         message: "expected any decimal digit but found \\"a\\"", position: nil}]}

  """
  defparser integer in p do
    r = many1(digit()).(p)

    case r.status do
      :ok ->
        {val, _} =  r.result
                 |> to_string
                 |> Integer.parse
        success(p, %Token{type: :int, value: val})
      :error -> r
    end
  end
end