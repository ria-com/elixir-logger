# Ria.Logger

  Ria.Logger - simple logger like IO.inspect that can show module, function and line

```elixir
  alias Ria.Logger
  # ...
  %{
    x: 1,
    y: 2,
  }
  |> Logger.inspect(__ENV__)
  # 2017-11-15 12:45:05 - MyModule:my_function:18 - %{x: 1, y: 2}
```

## Installation

```elixir
def deps do
  [{:ria_logger, git: "https://github.com/ria-com/elixir-logger.git"}]
end
```

## Testing

```bash
[elixir-logger]# mix test
```
