defmodule BoutiqueInventory do
  @type item :: %{price: integer, name: String.t(), quantity_by_size: map}

  @spec sort_by_price([item]) :: [item]
  def sort_by_price(inventory), do: Enum.sort_by(inventory, &get_in(&1, [:price]))

  @spec with_missing_price([item]) :: [item]
  def with_missing_price(inventory),
    do: Enum.filter(inventory, fn %{price: price} -> is_nil(price) end)

  @spec update_names([item], String.t(), String.t()) :: [item]
  def update_names(inventory, old_word, new_word) do
    Enum.map(
      inventory,
      fn item -> Map.update!(item, :name, &String.replace(&1, old_word, new_word)) end
    )
  end

  @spec increase_quantity(item, number) :: item
  def increase_quantity(item, count),
    do: Map.update!(item, :quantity_by_size, &Map.new(&1, fn {k, v} -> {k, v + count} end))

  @spec total_quantity(item) :: number
  def total_quantity(%{quantity_by_size: quantity_by_size}),
    do: Enum.reduce(quantity_by_size, 0, fn {_, v}, acc -> v + acc end)
end
