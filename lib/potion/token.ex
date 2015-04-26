defmodule Potion.Token do
  @moduledoc """
  Defines some stuff to work with tokens
  """

  @typedoc ~S"The type of an `Potion.Token` instance"
  @type t() :: %__MODULE__{type: type | nil,
                           value: any}
  @typedoc ~S"Possible types a `Potion.Token` can have"
  @type type :: :keyword | :int | :string | :float

  defstruct type: nil, value: nil

  @types [:keyword, :int, :string, :float, :operator]
  @keywords []
  @op_chars "/*-+!§$%&=~_.<>|¦"

  @doc """
  Creates a new instance of `Potion.Token`.

  ## Examples

      iex> Potion.Token.new :int, 1
      %Potion.Token{type: :int, value: 1}

      iex> Potion.Token.new :float, 1.0
      %Potion.Token{type: :float, value: 1.0}

      iex> Potion.Token.new :string, "foo"
      %Potion.Token{type: :string, value: "foo"}

      iex> Potion.Token.new :string, 1
      nil
  """
  def new(type, value) do
    token = %Potion.Token{type: type, value: value}
    if valid? token do
      token
    else
      nil
    end
  end

  @doc """
  Checks if a value is a `Potion.Token` instance

  ## Examples

      iex(1)> Potion.Token.valid? "foo"
      false

      iex(2)> Potion.Token.valid? %Potion.Token{type: :int, value: 12}
      true

      iex(3)> Potion.Token.valid? %Potion.Token{type: :float, value: 12.0}
      true

      iex(4)> Potion.Token.valid? %Potion.Token{type: :string, value: "foo"}
      true

      iex(5)> Potion.Token.valid? %Potion.Token{type: :string, value: 12.0} 
      false
  """
  @spec valid?(any) :: boolean
  def valid?(tok = %Potion.Token{}) do
    if Enum.find(@types, false, fn(x) -> x == tok.type end) do
      case tok.type do
        :keyword  -> valid_keyword?(tok)
        :int      -> valid_int?(tok)
        :string   -> valid_string?(tok)
        :float    -> valid_float?(tok)
        :operator -> valid_operator?(tok)
        _         -> false
      end
    end
  end

  def valid?(_), do: false

  defp valid_keyword?(tok) do
    case tok.type do
      :keyword -> Enum.find(@keywords, false, fn(x) -> x == tok.value end)
      _        -> false
    end
  end

  defp valid_int?(tok) do
    case tok.type do
      :int -> is_integer tok.value
      _    -> false
    end
  end

  defp valid_string?(tok) do
    case tok.type do
      :string -> String.valid? tok.value
      _       -> false
    end
  end

  defp valid_float?(tok) do
    case tok.type do
      :float -> is_float tok.value
      _      -> false
    end
  end

  defp valid_operator?(tok) do
    case tok.type do
      :operator -> String.valid?(tok.value) && only_op_chars?(tok.value)
      _         -> false
    end
  end

  defp only_op_chars?(op_string) do
    String.codepoints(op_string) |> Enum.all(fn(cp) ->
      String.contains? @op_chars, cp
    end)
  end
end