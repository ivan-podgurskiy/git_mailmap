defmodule GitMailmap.Serializer do
  @moduledoc false

  @spec serialize([GitMailmap.entry()]) :: String.t()
  def serialize(entries) when is_list(entries), do: Enum.map_join(entries, &serialize_entry/1)

  defp serialize_entry(%{old_name: old_name, new_email: nil}) when not is_nil(old_name) do
    raise ArgumentError, "a name-specific entry requires a canonical email"
  end

  defp serialize_entry(%{old_name: old_name, new_email: new_email} = entry)
       when not is_nil(old_name) do
    "#{name_prefix(entry.new_name)}<#{new_email}> #{old_name} <#{entry.old_email}>\n"
  end

  defp serialize_entry(%{old_name: nil, new_email: new_email} = entry)
       when not is_nil(new_email) do
    "#{name_prefix(entry.new_name)}<#{new_email}> <#{entry.old_email}>\n"
  end

  defp serialize_entry(%{old_name: nil, new_email: nil, new_name: new_name} = entry)
       when not is_nil(new_name) do
    "#{name_prefix(new_name)}<#{entry.old_email}>\n"
  end

  defp serialize_entry(_entry) do
    raise ArgumentError, "a mailmap entry must change a name or email"
  end

  defp name_prefix(nil), do: ""

  defp name_prefix(name) do
    leading_space = if String.starts_with?(name, "#"), do: " ", else: ""
    "#{leading_space}#{name} "
  end
end
