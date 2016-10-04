[![Build Status](https://travis-ci.org/C404/sift_ex.svg?branch=master)](https://travis-ci.org/C404/sift_ex)
[![Hex.pm](https://img.shields.io/hexpm/v/sift_ex.svg)](https://hex.pm/packages/sift_ex)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
# Siftscience API Library for Elixir
This library (based on the official [SiftScience](https://github.com/SiftScience) libraries) allows you to interact with the SiftScience API via various functions in Elixir.

## Installation

First, add sift_ex to your `mix.exs` dependencies:

```elixir
def deps do
  [{:sift_ex, "~> 0.1"}]
end
```
and run `$ mix deps.get`.


## Usage

**Set your Sift API key**

One way `sift_api_key=YOUR_API_KEY iex -S mix`<br />
Or the other `System.put_env("sift_api_key", YOUR_API_KEY)`

**Set your Account ID (optional)**

One way `sift_account_id=YOUR_API_KEY iex -S mix`<br />
Or the other `System.put_env("sift_account_id", YOUR_ACCOUNT_ID)`



```iex
iex> SiftEx.start

# send a transaction event -- note this is blocking
iex> event = "$transaction"

iex> user_id = "23069"  # User ID's may only contain a-z, A-Z, 0-9, =, ., -, _, +, @, :, &, ^, %, !, $

iex> properties = %{
 "$user_id" => user_id,
  "$user_email" => "buyer@gmail.com",
  "$seller_user_id" => "2371",
  "seller_user_email" => "seller@gmail.com",
  "$transaction_id" => "573050",
  "$payment_method" => %{
    "$payment_type"    => "$credit_card",
    "$payment_gateway" => "$braintree",
    "$card_bin"        => "542486",
    "$card_last4"      => "4444"             
  },
  "$currency_code" => "USD",
  "$amount" => 15230000,
}

iex> response = SiftEx.track(event, properties)

iex> response["status"]  # returns Sift status, default is 0
iex> response["error_message"]  # returns Sift error message, default is "OK"
iex> IO.inspect response # for more details of the response format

# Request a score for the user with user_id 23069
response = SiftEx.score(user_id)

# Label the user with user_id 23069 as Bad with all optional fields
iex> response = SiftEx.label(user_id, %{
  "$is_bad" => true,
  "$abuse_type" => "payment_abuse",
  "$description" => "Chargeback issued",
  "$source" => "Manual Review",
  "$analyst" => "analyst.name@your_domain.com"
})

# Get the status of a workflow run
iex> response = SiftEx.get_workflow_status('my_run_id')

# Get the latest decisions for a user
iex> response = SiftEx.get_user_decisions('example_user_id')

# Get the latest decisions for an order
iex> response = SiftEx.get_order_decisions('example_order_id')
```

Check out the official documentation [here](https://siftscience.com/developers/docs/curl/apis-overview) for more informations


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Testing

Various tests included, just run;

    mix deps.get
    mix test

## License

Copyright (c) 2015 Thibault Hagler. See the LICENSE file for license rights and limitations (MIT).
