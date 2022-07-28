defmodule NameBadge do
  def print(id, name, department) do
    id = if not is_nil(id), do: "[#{id}] - ", else: ""
    department = (if is_nil(department), do: "OWNER", else: department) |> String.upcase()
    id <> name <> " - " <> department
  end
end
