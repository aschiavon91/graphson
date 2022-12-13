defmodule Graphson.VertexProperty do
  @type t(vertex_id) :: %__MODULE__{
          label: String.t(),
          id: number(),
          value: any(),
          vertex: vertex_id
        }

  @enforce_keys [:label, :id, :value]
  @derive Jason.Encoder

  defstruct [:label, :id, :value, :vertex]

  def new!(%{
        "id" => %{"@value" => id},
        "vertex" => %{"@value" => vertex_id},
        "value" => value,
        "label" => label
      }) do
    %__MODULE__{label: label, id: id, vertex: vertex_id, value: value}
  end

  def new!(%{"id" => %{"@value" => id}, "label" => label, "value" => value}) do
    %__MODULE__{label: label, id: id, value: value}
  end

  def new!(_), do: raise RuntimeError, "#{__MODULE__}.new/1 invalid arguments"
end
