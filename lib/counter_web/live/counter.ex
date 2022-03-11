defmodule CounterWeb.Counter do
  use Phoenix.LiveView
  alias Counter.Count
  alias Phoenix.PubSub
  alias Counter.Presence

  # @topic "live"
  @topic Count.topic()
  @presence_topic "presence"
  # defines a module attribute (think of it as a global constant), that lets us to reference @topic anywhere in the file.

  # implementing certain functions for our live view to work.
  def mount(_params, _session, socket) do
    #  CounterWeb.Endpoint.subscribe(@topic) # subscribe to the channel,  mount/3 function now creates a subscription to the topic:
    PubSub.subscribe(Counter.PubSub, @topic)

    Presence.track(self(), @presence_topic, socket.id, %{})
    CounterWeb.Endpoint.subscribe(@presence_topic)

    inital_present =
      Presence.list(@presence_topic)
      |> map_size

    {:ok, assign(socket, val: Count.current(), present: inital_present)}
  end

  # handle the increment, adding +1 || OLD CODE IS OUTCOMMENTED; NEW CODE IS IMPLEMENTED.
  # pattern matching the string "inc" |> more about functions: https://elixirschool.com/en/lessons/basics/functions/#named-functions
  def handle_event("inc", _, socket) do
    #  new_state = update(socket, :val, (&(&1 + 1)))
    #  CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, assign(socket, :val, Count.incr())}
  end

  # handle the decrement, removing -1
  def handle_event("dec", _, socket) do
    #  new_state = update(socket, :val, (&(&1 - 1)))
    #  CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    # The new_state.assigns is a Map
    # that includes the key val where the value is 1 (after we clicked on the increment button).
    {:noreply, assign(socket, :val, Count.decr())}
  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, val: count)}
  end

  # handle_info/2 handles Elixir process messages where msg is the received message and socket is the Phoenix.Socket.
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
      ) do
    new_present = present + map_size(joins) - map_size(leaves)

    {:noreply, assign(socket, :present, new_present)}
  end

  # render and display our counter
  def render(assigns) do
    ~L"""
    <div>
    <h1>The counter is <%= @val %></h1>
    <button phx-click="dec">-</button>
    <button phx-click="inc">+</button>
    <h1>Current users: <%= @present %></h1>
    </div>
    """
  end
end
