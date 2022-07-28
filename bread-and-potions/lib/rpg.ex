defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    @spec eat(any, %Character{}) :: {any, %Character{}}
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    @spec eat(%LoafOfBread{}, %Character{}) :: {nil, %Character{}}
    def eat(%LoafOfBread{}, %Character{health: h} = c),
      do: {nil, %{c | health: h + 5}}
  end

  defimpl Edible, for: ManaPotion do
    @spec eat(%ManaPotion{}, %Character{}) :: {%EmptyBottle{}, %Character{}}
    def eat(%ManaPotion{strength: s}, %Character{mana: m} = c),
      do: {%EmptyBottle{}, %{c | mana: m + s}}
  end

  defimpl Edible, for: Poison do
    @spec eat(%Poison{}, %Character{}) :: {%EmptyBottle{}, %Character{}}
    def eat(%Poison{}, c), do: {%EmptyBottle{}, %{c | health: 0}}
  end
end
