defmodule Graphson.Vertex do
  alias Graphson.VertexProperty

  @type vertex_id :: number()

  @type t() :: %__MODULE__{
          label: String.t(),
          id: vertex_id,
          properties: VertexProperty.t(vertex_id) | nil
        }

  @enforce_keys [:label, :id]
  @derive Jason.Encoder

  defstruct [:label, :id, :properties]

  def new!(%{"id" => id} = args) when is_map(id) do
    args
    |> Map.update!("id", &Graphson.decode!/1)
    |> new!()
  end

  def new!(%{"id" => id, "label" => label} = args) do
    properties =
      args
      |> Map.get("properties", %{})
      |> Graphson.decode!()

    %__MODULE__{id: id, label: label, properties: properties}
  end

  def new!(_), do: raise(RuntimeError, "#{__MODULE__}.new!/1 invalid arguments")

  def add_properties!(%__MODULE__{properties: nil} = vertex, properties) do
    %__MODULE__{vertex | properties: properties}
  end

  def add_properties!(%__MODULE__{properties: current_properties} = vertex, new_properties) do
    properties = Map.merge(current_properties, new_properties)

    %__MODULE__{vertex | properties: properties}
  end

  def add_properties!(_),
    do: raise(RuntimeError, "#{__MODULE__}.add_properties!/1 invalid arguments")
end
