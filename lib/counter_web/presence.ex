defmodule Counter.Presence do
  use Phoenix.Presence,
    otp_app: :live_view_counter,
    pubsub_server: Counter.PubSub
end
