defmodule Username do  
  @spec substitute_char(char) :: charlist
  defp substitute_char(c) do
    case c do
      ?ä -> 'ae'
      ?ö -> 'oe'
      ?ü -> 'ue'
      ?ß -> 'ss'
      x when x in ?a..?z or x === ?_ -> [x]
      _ -> ''
    end
  end

  @spec sanitize(charlist) :: charlist
  def sanitize(username) do
    Enum.flat_map(username, &substitute_char/1)
  end
end
