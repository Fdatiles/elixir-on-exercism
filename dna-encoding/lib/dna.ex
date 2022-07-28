defmodule DNA do
  def encode_nucleotide(code_point)
  def encode_nucleotide(?\s), do: 0b0000
  def encode_nucleotide(?A), do: 0b0001
  def encode_nucleotide(?C), do: 0b0010
  def encode_nucleotide(?G), do: 0b0100
  def encode_nucleotide(?T), do: 0b1000

  def decode_nucleotide(encoded_code)
  def decode_nucleotide(0b0000), do: ?\s
  def decode_nucleotide(0b0001), do: ?A
  def decode_nucleotide(0b0010), do: ?C
  def decode_nucleotide(0b0100), do: ?G
  def decode_nucleotide(0b1000), do: ?T

  @spec encode(charlist) :: bitstring
  def encode(dna), do: encode(list_reverse(dna), <<>>)
  defp encode([], acc), do: acc

  defp encode([c | tail], acc),
    do: encode(tail, <<encode_nucleotide(c)::4, acc::bitstring>>)

  @spec decode(bitstring) :: [?\s | ?A | ?C | ?G | ?T]
  def decode(dna), do: decode(dna, [])
  defp decode(<<>>, acc), do: list_reverse(acc)

  defp decode(<<nucl::4, tail::bitstring>>, acc),
    do: decode(tail, [decode_nucleotide(nucl) | acc])

  defp list_reverse(list), do: list_reverse(list, [])
  defp list_reverse([], acc), do: acc
  defp list_reverse([head | tail], acc), do: list_reverse(tail, [head | acc])
end
