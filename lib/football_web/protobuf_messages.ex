defmodule FootballWeb.ProtobufMessages do
  use Protobuf, from: Path.wildcard(Path.expand("../../config/proto/*.proto", __DIR__))
end
