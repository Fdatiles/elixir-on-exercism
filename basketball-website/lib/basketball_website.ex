defmodule BasketballWebsite do
  @spec extract_from_path(map, String.t()) :: any
  def extract_from_path(data, path), do: do_extract_from_path(data, String.split(path, "."))

  @spec do_extract_from_path(map, [String.t()]) :: any
  defp do_extract_from_path(data, keys)
  defp do_extract_from_path(data, []), do: data
  defp do_extract_from_path(data, [key | tail]), do: do_extract_from_path(data[key], tail)

  @spec get_in_path(map, String.t()) :: any
  def get_in_path(data, path),
    do: get_in(data, String.split(path, "."))
end
