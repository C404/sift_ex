defmodule SiftExTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("test/cassettes")
    ExVCR.Config.filter_sensitive_data(~s([$]?api_key\\":\\"[^&\\"]+), "$api_key\":\"CREDENTIALS")
    ExVCR.Config.filter_sensitive_data(~s(api_key=[^&]+), "api_key=CREDENTIALS")
    ExVCR.Config.filter_sensitive_data(~s(\\\\\\"[$]api_key\\\\\\":\\\\\\"[^\\ ]+\\\\\\"), "\\\"$api_key\\\":\\\"CREDENTIALS\\\"")

    SiftEx.start

    :ok
  end

  test ".track event call with properties" do
    use_cassette "track_success" do

      event = "$transaction"
      user_id = "666069"

      properties = %{
       "$user_id" => user_id,
        "$user_email" => "buyer@gmail.com",
        "$seller_user_id" => "23671",
        "seller_user_email" => "seller@gmail.com",
        "$transaction_id" => "573040",
        "$payment_method" => %{
          "$payment_type"    => "$credit_card",
          "$payment_gateway" => "$braintree",
          "$card_bin"        => "542486",
          "$card_last4"      => "4444"
        },
        "$currency_code" => "USD",
        "$amount" => 15230000,
      }

      response = SiftEx.track(event, properties)

      assert 0 == response["status"]
      assert "OK" == response["error_message"]
    end
  end

  test ".label call with properties" do
    use_cassette "label_success" do

      user_id = "666069"

      properties = %{
        "$is_bad" => true,
        "$abuse_type" => "payment_abuse",
        "$description" => "Chargeback issued",
        "$source" => "Manual Review",
        "$analyst" => "analyst.name@your_domain.com"
      }

      response = SiftEx.label(user_id, properties)

      assert 0 == response["status"]
      assert "OK" == response["error_message"]
    end
  end

  test ".scope call" do
    use_cassette "score_success" do

      user_id = "666069"

      response = SiftEx.score(user_id)

      assert 0 == response["status"]
      assert "OK" == response["error_message"]
      assert true == response["latest_labels"]["payment_abuse"]["is_bad"]
    end
  end

  test ".unlabel call" do
    use_cassette "unlabel_success" do

      user_id = "666069"

      response = SiftEx.unlabel(user_id)

      assert 0 == response["status"]
      assert "OK" == response["error_message"]
    end
  end
end
