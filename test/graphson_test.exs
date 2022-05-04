defmodule GraphsonTest do
  use ExUnit.Case

  describe "decode/1" do
    test "g:Class" do
      assert "SomeClass" == Graphson.decode(%{"@type" => "g:Class", "@value" => "SomeClass"})
    end

    test "g:Date" do
      assert ~U[2016-12-14 21:14:36.295Z] ==
               Graphson.decode(%{"@type" => "g:Date", "@value" => 1_481_750_076_295})
    end

    test "g:Double" do
      assert 100.0 ==
               Graphson.decode(%{
                 "@type" => "g:Double",
                 "@value" => 100.0
               })
    end

    test "g:Float" do
      assert 100.0 ==
               Graphson.decode(%{
                 "@type" => "g:Float",
                 "@value" => 100.0
               })
    end

    test "g:Int32" do
      assert 100 ==
               Graphson.decode(%{
                 "@type" => "g:Int32",
                 "@value" => 100
               })
    end

    test "g:Int64" do
      assert 100 ==
               Graphson.decode(%{
                 "@type" => "g:Int64",
                 "@value" => 100
               })
    end

    test "g:List" do
      assert [1, "person", true] ==
               Graphson.decode(%{
                 "@type" => "g:List",
                 "@value" => [
                   %{
                     "@type" => "g:Int32",
                     "@value" => 1
                   },
                   "person",
                   true
                 ]
               })
    end

    test "g:Map" do
      unparsed = %{
        "@type" => "g:Map",
        "@value" => [
          %{
            "@type" => "g:Date",
            "@value" => 1_481_750_076_295
          },
          "red",
          %{
            "@type" => "g:List",
            "@value" => [
              %{
                "@type" => "g:Int32",
                "@value" => 1
              },
              %{
                "@type" => "g:Int32",
                "@value" => 2
              },
              %{
                "@type" => "g:Int32",
                "@value" => 3
              }
            ]
          },
          %{
            "@type" => "g:Date",
            "@value" => 1_481_750_076_295
          },
          "test",
          %{
            "@type" => "g:Int32",
            "@value" => 123
          }
        ]
      }

      assert %{
               ~U[2016-12-14 21:14:36.295Z] => "red",
               [1, 2, 3] => ~U[2016-12-14 21:14:36.295Z],
               "test" => 123
             } == Graphson.decode(unparsed)
    end

    test "g:Set" do
      unparsed = %{
        "@type" => "g:Set",
        "@value" => [
          %{
            "@type" => "g:Int32",
            "@value" => 1
          },
          "person",
          true
        ]
      }

      assert %MapSet{map: %{1 => [], true => [], "person" => []}} == Graphson.decode(unparsed)
    end

    test "g:Timestamp" do
      assert ~U[2016-12-14 21:14:36.295Z] ==
               Graphson.decode(%{
                 "@type" => "g:Timestamp",
                 "@value" => 1_481_750_076_295
               })
    end

    test "g:UUID" do
      assert "41d2e28a-20a4-4ab0-b379-d810dede3786" ==
               Graphson.decode(%{
                 "@type" => "g:UUID",
                 "@value" => "41d2e28a-20a4-4ab0-b379-d810dede3786"
               })
    end

    test "g:Edge" do
      unparsed = %{
        "@type" => "g:Edge",
        "@value" => %{
          "id" => %{
            "@type" => "g:Int32",
            "@value" => 13
          },
          "label" => "develops",
          "inVLabel" => "software",
          "outVLabel" => "person",
          "inV" => %{
            "@type" => "g:Int32",
            "@value" => 10
          },
          "outV" => %{
            "@type" => "g:Int32",
            "@value" => 1
          },
          "properties" => %{
            "since" => %{
              "@type" => "g:Property",
              "@value" => %{
                "key" => "since",
                "value" => %{
                  "@type" => "g:Int32",
                  "@value" => 2009
                }
              }
            }
          }
        }
      }

      assert %Graphson.Edge{
               id: 13,
               in_vertex: %Graphson.Vertex{id: 10, label: "software", properties: nil},
               label: "develops",
               out_vertex: %Graphson.Vertex{id: 1, label: "person", properties: nil},
               properties: %{since: 2009}
             } == Graphson.decode(unparsed)
    end

    test "g:Vertex" do
      unparsed = %{
        "@type" => "g:Vertex",
        "@value" => %{
          "id" => %{
            "@type" => "g:Int32",
            "@value" => 1
          },
          "label" => "person",
          "properties" => %{
            "name" => [
              %{
                "@type" => "g:VertexProperty",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int64",
                    "@value" => 0
                  },
                  "value" => "marko",
                  "label" => "name"
                }
              }
            ],
            "location" => [
              %{
                "@type" => "g:VertexProperty",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int64",
                    "@value" => 6
                  },
                  "value" => "san diego",
                  "label" => "location",
                  "properties" => %{
                    "startTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 1997
                    },
                    "endTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2001
                    }
                  }
                }
              },
              %{
                "@type" => "g:VertexProperty",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int64",
                    "@value" => 7
                  },
                  "value" => "santa cruz",
                  "label" => "location",
                  "properties" => %{
                    "startTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2001
                    },
                    "endTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2004
                    }
                  }
                }
              },
              %{
                "@type" => "g:VertexProperty",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int64",
                    "@value" => 8
                  },
                  "value" => "brussels",
                  "label" => "location",
                  "properties" => %{
                    "startTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2004
                    },
                    "endTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2005
                    }
                  }
                }
              },
              %{
                "@type" => "g:VertexProperty",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int64",
                    "@value" => 9
                  },
                  "value" => "santa fe",
                  "label" => "location",
                  "properties" => %{
                    "startTime" => %{
                      "@type" => "g:Int32",
                      "@value" => 2005
                    }
                  }
                }
              }
            ]
          }
        }
      }

      assert %Graphson.Vertex{
               id: 1,
               label: "person",
               properties: %{
                 location: [
                   %Graphson.VertexProperty{
                     id: 6,
                     label: "location",
                     value: "san diego",
                     vertex: nil
                   },
                   %Graphson.VertexProperty{
                     id: 7,
                     label: "location",
                     value: "santa cruz",
                     vertex: nil
                   },
                   %Graphson.VertexProperty{
                     id: 8,
                     label: "location",
                     value: "brussels",
                     vertex: nil
                   },
                   %Graphson.VertexProperty{
                     id: 9,
                     label: "location",
                     value: "santa fe",
                     vertex: nil
                   }
                 ],
                 name: [
                   %Graphson.VertexProperty{id: 0, label: "name", value: "marko", vertex: nil}
                 ]
               }
             } == Graphson.decode(unparsed)
    end

    test "g:VertexProperty" do
      unparsed = %{
        "@type" => "g:VertexProperty",
        "@value" => %{
          "id" => %{
            "@type" => "g:Int64",
            "@value" => 0
          },
          "value" => "marko",
          "label" => "name"
        }
      }

      assert %Graphson.VertexProperty{
               id: 0,
               label: "name",
               value: "marko",
               vertex: nil
             } ==
               Graphson.decode(unparsed)
    end

    test "g:Path" do
      unparsed = %{
        "@type" => "g:Path",
        "@value" => %{
          "labels" => %{
            "@type" => "g:List",
            "@value" => [
              %{
                "@type" => "g:Set",
                "@value" => []
              },
              %{
                "@type" => "g:Set",
                "@value" => []
              },
              %{
                "@type" => "g:Set",
                "@value" => []
              }
            ]
          },
          "objects" => %{
            "@type" => "g:List",
            "@value" => [
              %{
                "@type" => "g:Vertex",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int32",
                    "@value" => 1
                  },
                  "label" => "person"
                }
              },
              %{
                "@type" => "g:Vertex",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int32",
                    "@value" => 10
                  },
                  "label" => "software"
                }
              },
              %{
                "@type" => "g:Vertex",
                "@value" => %{
                  "id" => %{
                    "@type" => "g:Int32",
                    "@value" => 11
                  },
                  "label" => "software"
                }
              }
            ]
          }
        }
      }

      assert %{
               labels: [%MapSet{}, %MapSet{}, %MapSet{}],
               objects: [
                 %Graphson.Vertex{id: 1, label: "person", properties: %{}},
                 %Graphson.Vertex{id: 10, label: "software", properties: %{}},
                 %Graphson.Vertex{id: 11, label: "software", properties: %{}}
               ]
             } == Graphson.decode(unparsed)
    end
  end
end
