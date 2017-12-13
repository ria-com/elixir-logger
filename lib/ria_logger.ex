defmodule Ria.Logger do
  alias Ria.Request

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
    any
    |> format(%{module: module, function: function, line: line})
    |> IO.puts
    any
  end

  def format(any, %{module: module, function: function, line: line}) do
    "#{
      DateTime.utc_now
      |> DateTime.to_string
      |> String.split(".")
      |> List.first
    } - #{
      module
      |> Atom.to_string
      |> String.split(".")
      |> List.last
    }:#{
      function
      |> Tuple.to_list
      |> List.first
    }:#{line} - #{
      Kernel.inspect(any, pretty: true, width: 48)
    }"
  end

  @doc """
    Ria.Logger.log - simple logger to ElastticSearch

      iex> Ria.Logger.log(%{data: "some text"})
      %{"_id" => "20171208130100", "_index" => "log", "_type" => "cron", "_version" => 1, "created" => true}

  """
  def log(message, index, %DateTime{ year: year, month: month, day: day, zone_abbr: zone_abbr, hour: hour, minute: minute, second: second, microsecond: microsecond, utc_offset: utc_offset, std_offset: std_offset, time_zone: time_zone}, %{module: module, function: function, line: line}), do: log(
      message,
      index,
      %DateTime{ year: year, month: month, day: day, zone_abbr: zone_abbr, hour: hour, minute: minute, second: second, microsecond: microsecond, utc_offset: utc_offset, std_offset: std_offset, time_zone: time_zone}
      |> DateTime.to_string
      |> String.slice(0, 19)
      |> String.replace(~r/[ :-]/,""),
      %{module: module, function: function, line: line}
    )
  def log(message, index, key, %{module: module, function: function, line: line}) when is_bitstring(key) do
    Request.json("#{Application.get_env(:ria_logger, :types).elasticsearch.url}/log/#{index}/#{key}/_update",
      Poison.encode!(%{
        script: "ctx._source.logs += log",
        params: %{
          log: (Ria.Logger.format(message, %{module: module, function: function, line: line}))
        },
        "upsert": %{
          logs: [Ria.Logger.format(message, %{module: module, function: function, line: line})],
          date: DateTime.utc_now
        }
      })
    )
    message
  end
  def log(message, index, key, %{module: module, function: function, line: line}), do: log(message, index, Kernel.inspect(key), %{module: module, function: function, line: line})
end
