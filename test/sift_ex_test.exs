defmodule SiftExTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/cassettes")
    :ok
  end

  test ".track event call with properties" do
    use_cassette "track_success" do

      assert "234 km" == response["rows"]
                         |> List.first
                         |> Map.get("elements")
                         |> List.first
                         |> Map.get("distance")
                         |> Map.get("text")
    end
  end
end
