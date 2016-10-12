defmodule SiftEx do
  @api_url "https://api.siftscience.com"
  @api3_url "https://api3.siftscience.com"
  @api_version "v204"

  alias SiftEx.PathBuilder, as: PathBuilder

  def start do
    if is_nil(sift_api_key) && Mix.env == :prod, do: raise SiftEx.Error

    HTTPoison.start
  end

  @doc """
    Sends an event to the Sift Science Events API.

    See https://siftscience.com/developers/docs/ruby/events-api

    ==== Parameters:

    event:
      The name of the event to send. This can be either a reserved
      event name, like $transaction or $label or a custom event name
      (that does not start with a $).  This parameter must be
      specified.

    properties:
      A map of name-value pairs that specify the event-specific
      attributes to track.  This parameter must be specified.
      example:
       properties = %{
         "$user_id" =>  "23034",
         "$type"          => "$create_order",
         "$user_id"       => "billy_jones_301",
         "$order_id"      => "ORDER-28168441",
         "$user_email"    => "bill@gmail.com",
         "$amount"        => 115940000,
         "$currency_code" => "USD"
       }

    abuse_types (optional):
        List of abuse types, specifying for which abuse types a
        score should be returned (if scoring was requested).  By
        default, a score is returned for every abuse type to which
        you are subscribed.
  """
  def track(event, properties, abuse_types \\ []) when is_binary(event) and is_map(properties) do
    url = @api_url <> PathBuilder.rest_api_path(@api_version)

    {:ok, %HTTPoison.Response{body: body}} = post_properties(url, event, properties, abuse_types)

    Poison.decode!(body)
  end


  @doc """
    Retrieves a user's fraud score from the Sift Science API.

    See See https://siftscience.com/developers/docs/ruby/score-api/score-api

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.

   abuse_types (optional):
       List of abuse types, specifying for which abuse types a
       score should be returned (if scoring was requested).  By
       default, a score is returned for every abuse type to which
       you are subscribed.
  """
  def score(user_id, abuse_types \\ []) when is_binary(user_id) do
    url = @api_url <> PathBuilder.score_api_path(user_id, @api_version)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], params: query_params(abuse_types))

    Poison.decode!(body)
  end


  @doc """
    Labels a user.

    See https://siftscience.com/developers/docs/ruby/labels-api/label-user

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.

     properties:
       A map of name-value pairs that specify the event-specific
       attributes to track.  This parameter must be specified.
       example:
        properties = %{
          "$user_id" =>  "23034",
          "$type"          => "$create_order",
          "$user_id"       => "billy_jones_301",
          "$order_id"      => "ORDER-28168441",
          "$user_email"    => "bill@gmail.com",
          "$amount"        => 115940000,
          "$currency_code" => "USD"
        }
  """
  def label(user_id, properties) when is_binary(user_id) do
    url = @api_url <> PathBuilder.users_label_api_path(user_id, @api_version)

    {:ok, %HTTPoison.Response{body: body}} = post_properties(url, "$label", properties)

    Poison.decode!(body)
  end


  @doc """
    Unlabels a user.

    See https://siftscience.com/developers/docs/ruby/labels-api/unlabel-user

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.
  """
  def unlabel(user_id) when is_binary(user_id) do
    url = @api_url <> PathBuilder.users_label_api_path(user_id, @api_version)

    {:ok, %HTTPoison.Response{status_code: 204}} = HTTPoison.delete(url, [], params: query_params)

    %{"error_message" => "OK", "status" => 0}
  end

  @doc """
    Gets the status of a workflow run.

    See https://siftscience.com/developers/docs/ruby/workflows-api/workflow-status

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.
  """
  def get_workflow_status(run_id) when is_binary(run_id) do
    url = @api3_url <> PathBuilder.workflow_status_path(account_id, run_id)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], params: query_params)

    Poison.decode!(body)
  end


  @doc """
    Gets the decision status of a user.

    See https://siftscience.com/developers/docs/ruby/decisions-api/decision-status

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.
  """
  def get_user_decisions(user_id) when is_binary(user_id) do
    url = @api3_url <> PathBuilder.user_decisions_api_path(account_id, user_id)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], params: query_params)

    Poison.decode!(body)
  end


  @doc """
    Gets the decision status of an order.

    See https://siftscience.com/developers/docs/ruby/decisions-api/decision-status

    ==== Parameters:

    user_id:
       A user's id. This id should be the same as the user_id used in
       event calls.
  """
  def get_order_decisions(order_id) when is_binary(order_id) do
    url = @api3_url <> PathBuilder.order_decisions_api_path(account_id, order_id)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url, [], params: query_params)

    Poison.decode!(body)
  end

  defp post_properties(url, event, properties, abuse_types \\ []) do
    body = properties
    |> Map.merge(%{"$type" => event, "$api_key" => sift_api_key})
    |> Poison.encode!

    HTTPoison.post(url, body, [], params: %{abuse_types: Enum.join(abuse_types, ",")})
  end

  defp query_params(abuse_types \\ []) do
    %{api_key: sift_api_key, abuse_types: Enum.join(abuse_types, ",")}
  end


  defp account_id do
    Application.get_env(:sift_ex, :account_id)
  end

  defp sift_api_key do
    Application.get_env(:sift_ex, :api_key)
  end
end
