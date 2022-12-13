defmodule Graphson.Edge do
  alias Graphson.Vertex

  @type t() :: %__MODULE__{
          label: String.t(),
          id: number(),
          properties: map(),
          in_vertex: Vertex.t(),
          out_vertex: Vertex.t()
        }

  @derive Jason.Encoder

  @enforce_keys [:label, :id, :in_vertex, :out_vertex, :properties]
  defstruct [:label, :id, :in_vertex, :out_vertex, :properties]

  def new!(
        %{
          "id" => edge_id,
          "inV" => in_v,
          "inVLabel" => in_v_label,
          "label" => label,
          "outV" => out_v,
          "outVLabel" => out_v_label
        } = value
      ) do
    id = Graphson.decode!(edge_id)
    in_v_id = Graphson.decode!(in_v)
    out_v_id = Graphson.decode!(out_v)

    properties =
      value
      |> Map.get("properties", %{})
      |> Graphson.decode!()

    in_vertex = %Vertex{id: in_v_id, label: in_v_label}
    out_vertex = %Vertex{id: out_v_id, label: out_v_label}

    %__MODULE__{
      id: id,
      label: label,
      in_vertex: in_vertex,
      out_vertex: out_vertex,
      properties: properties
    }
  end

  def new!(_), do: raise(RuntimeError, "#{__MODULE__}.new/1 invalid arguments")
end
