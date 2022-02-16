defmodule CounterWeb.Counter do
  use Phoenix.LiveView

  @topic "live"
  # defines a module attribute (think of it as a global constant), that lets us to reference @topic anywhere in the file.

  # implementing certain functions for our live view to work.
  def mount(_params, _session, socket) do
    CounterWeb.Endpoint.subscribe(@topic) # subscribe to the channel,  mount/3 function now creates a subscription to the topic:
    {:ok, assign(socket, :val, 0)}
  end

  # handle the increment, adding +1
  def handle_event("inc", _, socket) do # pattern matching the string "inc" |> more about functions: https://elixirschool.com/en/lessons/basics/functions/#named-functions
    new_state = update(socket, :val, (&(&1 + 1)))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, new_state}
  end

  # handle the decrement, removing -1
  def handle_event("dec", _, socket) do
    new_state = update(socket, :val, (&(&1 - 1)))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    # The new_state.assigns is a Map
    # that includes the key val where the value is 1 (after we clicked on the increment button).
    {:noreply, new_state}
  end

  # handle_info/2 handles Elixir process messages where msg is the received message and socket is the Phoenix.Socket.
  # The line {:noreply, assign(socket, val: msg.payload.val)} just means "don't send this message to the socket again" (which would cause a recursive loop of updates).
  def handle_info(msg, socket) do
    {:noreply, assign(socket, val: msg.payload.val)}
  end

  # render and display our counter
  def render(assigns) do
    ~L"""
    <div>
    <h1>The counter is <%= @val %></h1>
    <button phx-click="dec">-</button>
    <button phx-click="inc">+</button>
    </div>
    """
  end
end
