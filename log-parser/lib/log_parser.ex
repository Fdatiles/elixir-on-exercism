defmodule LogParser do
  @spec valid_line?(String.t()) :: boolean
  def valid_line?(line) when is_binary(line) do
    line =~ ~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/
  end

  @spec split_line(String.t()) :: [String.t()]
  def split_line(line) do
    String.split(line, ~r/<[~*=-]*>/)
  end

  @spec remove_artifacts(String.t()) :: String.t()
  def remove_artifacts(line) do
    String.replace(line, ~r/end-of-line\d+/i, "")
  end

  @spec tag_with_user_name(String.t()) :: String.t()
  def tag_with_user_name(line) do
    case Regex.run(~r/User\s+(\S+)/u, line, capture: :all_but_first) do
      :nil -> line
      [user] -> "[USER] #{user} #{line}"
    end
  end
end
