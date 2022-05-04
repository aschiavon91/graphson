defmodule Graphson do
  @moduledoc """
  Documentation for `Graphson`.
  """

  alias Graphson.Vertex
  alias Graphson.VertexProperty
  alias Graphson.Edge

  def decode(%{"@type" => "g:Vertex", "@value" => value}) do
    Vertex.new(value)
  end

  def decode(%{"@type" => "g:VertexProperty", "@value" => value}) do
    VertexProperty.new(value)
  end

  def decode(%{"@type" => "g:Edge", "@value" => value}) do
    Edge.new(value)
  end

  def decode(%{"@type" => type, "@value" => value}) when type in ["g:Date", "g:Timestamp"] do
    DateTime.from_unix!(value, :millisecond)
  end

  def decode(%{"@type" => "g:List", "@value" => value}) do
    Enum.map(value, &decode/1)
  end

  def decode(%{"@type" => "g:Map", "@value" => value}) do
    value
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn [key, value], acc ->
      Map.put(acc, decode(key), decode(value))
    end)
  end

  def decode(%{"@type" => "g:Set", "@value" => value}) do
    value
    |> Enum.map(&decode/1)
    |> MapSet.new()
  end

  def decode(%{"@type" => _, "@value" => value}) do
    decode(value)
  end

  def decode(%{"value" => value}) do
    decode(value)
  end

  def decode(properties) when is_map(properties) do
    Enum.reduce(properties, %{}, fn {label, property}, acc ->
      # FIXME: we need a better way to convert this keys, or just let this as string
      label = String.to_atom(label)
      values = decode(property)
      Map.put(acc, label, values)
    end)
  end

  def decode(properties) when is_list(properties) do
    Enum.map(properties, &decode/1)
  end

  def decode(value) do
    value
  end
end
