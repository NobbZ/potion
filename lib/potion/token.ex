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

      iex(6)> Potion.Token.valid? %Potion.Token{type: :operator, value: "+"}
      true

      iex(7)> Potion.Token.valid? %Potion.Token{type: :operator, value: "a"}
      false

      iex(8)> Potion.Token.valid? %Potion.Token{type: :operator, value: "|+|"}
      true
  """
  @spec valid?(any) :: boolean
  def valid?(%__MODULE__{type: :int,     value: val}) when is_integer(val),    do: true
  def valid?(%__MODULE__{type: :float,   value: val}) when is_float(val),      do: true
  def valid?(%__MODULE__{type: :string,  value: val}), do: String.valid?(val)
  def valid?(%__MODULE__{type: :keyword, value: val}) do
    if String.valid?(val) do
      Enum.find(@keywords, false, &(&1 == val))
    else
      false
    end
  end
  def valid?(%__MODULE__{type: :operator, value: val}) do
    if String.valid?(val) do
      String.codepoints(val) |> Enum.all?(fn(cp) ->
        String.contains? @op_chars, cp
      end)
    end
  end
  def valid?(_), do: false
end