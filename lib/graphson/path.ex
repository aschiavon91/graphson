defmodule Graphson.Path do
  @type t() :: %__MODULE__{
          labels: list(String.t()),
          objects: list(Vertex.t())
        }

  @enforce_keys [:labels, :objects]
  @derive Jason.Encoder
  defstruct labels: [], objects: []

  def new!(%{"labels" => labels, "objects" => objects}) do
    %__MODULE__{labels: Graphson.decode!(labels), objects: Graphson.decode!(objects)}
  end

  def new!(_), do: raise(RuntimeError, "#{__MODULE__}.new/1 invalid arguments")
end
