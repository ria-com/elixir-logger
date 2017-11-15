defmodule Ria.Logger do
 @moduledoc """
  Ria.Logger - simple logger like IO.inspect that can show module, function and line
  """

  def inspect(any), do: IO.inspect(any)
  def inspect(any, %{module: nil}), do: IO.inspect(any)
  def inspect(any, %{function: nil}), do: IO.inspect(any)

  @doc """
      iex> Ria.Logger.inspect(%{x: 1, y: 2})
      %{x: 1, y: 2}
  """
  def inspect(any, %{module: module, function: function, line: line}) do
    "#{DateTime.utc_now |> DateTime.to_string |> String.split(".") |> List.first} - #{module |> Atom.to_string |> String.split(".") |> List.last}:#{function |> Tuple.to_list |> List.first}:#{line} - #{Kernel.inspect(any, pretty: true, width: 48)}"
    |> IO.puts
    any
  end

end
