defmodule TopSecret do
  @spec to_ast(String.t()) :: Macro.t()
  def to_ast(string) when is_binary(string) do
    with {:ok, ast} <- Code.string_to_quoted(string), do: ast
  end

  @spec decode_secret_message_part(Macro.t(), list(String.t())) :: {Macro.t(), list(String.t())}
  def decode_secret_message_part(ast, acc)

  def decode_secret_message_part({h, _, [{:when, _, [{fun_name, _, args} | _]} | _]} = ast, acc)
      when h in [:def, :defp] do
    decode_secret_message_part(ast, Atom.to_string(fun_name), args, acc)
  end

  def decode_secret_message_part({h, _, [{fun_name, _, args} | _]} = ast, acc)
      when h in [:def, :defp] do
    decode_secret_message_part(ast, Atom.to_string(fun_name), args, acc)
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp decode_secret_message_part(ast, fun_name, args, acc) do
    arity =
      case args do
        nil -> 0
        l when is_list(l) -> length(l)
      end

    {ast, [String.slice(fun_name, 0, arity) | acc]}
  end

  @spec decode_secret_message(String.t()) :: String.t()
  def decode_secret_message(string) do
    {_ast, acc} =
      string
      |> to_ast()
      |> Macro.prewalk([], &decode_secret_message_part/2)

    acc |> Enum.reverse() |> Enum.join()
  end
end
