defmodule ProteinTranslation do
  @codon_table %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}
  def of_rna(rna) when is_binary(rna) do
    proteins =
      rna
      |> Stream.unfold(fn str ->
        case String.split_at(str, 3) do
          {"", _empty_rest} -> nil
          {_codon, _rest} = parts -> parts
        end
      end)
      |> Enum.reduce_while([], fn codon, acc ->
        case of_codon(codon) do
          {:ok, "STOP"} -> {:halt, acc}
          {:ok, protein} -> {:cont, [protein | acc]}
          {:error, _} = e -> {:halt, e}
        end
      end)

    case proteins do
      l when is_list(l) -> {:ok, Enum.reverse(l)}
      {:error, _} -> {:error, "invalid RNA"}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) when is_binary(codon) do
    case Map.fetch(@codon_table, codon) do
      {:ok, _} = r -> r
      :error -> {:error, "invalid codon"}
    end
  end
end
