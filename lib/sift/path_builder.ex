defmodule SiftEx.PathBuilder do

  # Returns the path for the specified API version
  def rest_api_path(version) do
    "/#{version}/events"
  end

  # Returns the Score API path for the specified user ID and API version
  def score_api_path(user_id, version) do
    "/#{version}/score/#{user_id}/"
  end

  # Returns the users API path for the specified user ID and API version
  def users_label_api_path(user_id, version) do
    "/#{version}/users/#{user_id}/labels"
  end

  # Returns the path for the Workflow Status API
  def workflow_status_path(account_id, run_id) do
    "/v3/accounts/#{account_id}/workflows/runs/#{run_id}"
  end

  # Returns the path for User Decisions API
  def user_decisions_api_path(account_id, user_id) do
    "/v3/accounts/#{account_id}/users/#{user_id}/decisions"
  end

  # Returns the path for Orders Decisions API
  def order_decisions_api_path(account_id, order_id) do
    "/v3/accounts/#{account_id}/orders/#{order_id}/decisions"
  end
end
