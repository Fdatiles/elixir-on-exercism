defmodule PigLatin do
  @vowels ~c[aeiou]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) when is_binary(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&transform_word/1)
    |> Enum.intersperse(" ")
    |> IO.chardata_to_string()
  end

  @spec transform_word(word :: String.t()) :: IO.chardata()
  defp transform_word(word) when is_binary(word) do
    case String.to_charlist(word) do
      # Starts with a simple vowel
      [v | _] = w when v in @vowels ->
        [w, "ay"]

      # Starts with ?x or ?y followed by a consonant
      [v, c | _] = w when v in [?x, ?y] and c not in @vowels ->
        [w, "ay"]

      # Starts with 'qu'
      [?q, ?u | rest] ->
        [rest, "quay"]

      # Starts with ?q alone
      [?q | rest] ->
        [rest, "qay"]

      # Starts with a single consonant followed by a vowel
      [c, v | rest] when c not in @vowels and v in @vowels ->
        [v, rest, c, "ay"]

      # Starts with one or more consonants
      _ ->
        midword_vowel = ~r/(?=[aeioy])|(?=(?<!q)u)/

        case Regex.split(midword_vowel, word, parts: 2) do
          [cs, rest] -> [rest, cs, "ay"]
          [cs] -> cs
        end
    end
  end
end
