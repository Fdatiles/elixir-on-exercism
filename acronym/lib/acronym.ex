defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) when is_binary(string) do
    words =
      string
      |> String.replace(~r/[^- a-zA-Z]+/, "")
      |> String.split(~r/[- ]+/)

    case words do
      [] ->
        ""

      l ->
        l
        |> Enum.map(fn
          "" -> ""
          s -> s |> String.first() |> String.upcase()
        end)
        |> Enum.into("")
    end
  end
end
