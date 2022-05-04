defmodule StagerWeb.LicenseLive do
  use StagerWeb, :live_view

  alias Stager.Licenses
  import Number.Currency

  def mount(_params, _session, socket) do
    socket = assign(socket, seats: 3, amount: Licenses.calculate(3))
    {:ok, socket}
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)
    {:noreply, assign(socket, seats: seats, amount: Licenses.calculate(seats))}
  end

  # value={"#{@seats}"}
  def render(assigns) do
    ~H"""
    <div class="relative pt-1">
      <span>Your License is currently for <strong><%= @seats %></strong> seats.</span>
      <br />
      <form phx-change="update">
        <label for="customRange1" class="form-label">Seats</label>
        <input
          type="range"
          class="
            form-range
            w-full
            h-6
            p-0
            bg-transparent
            focus:outline-none focus:ring-0 focus:shadow-md
          "
          id="customRange1"
          name="seats"
          min="1"
          max="10"
          value={@seats}
        />
      </form>
    </div>
    <div class="flex space-x-2 justify-center">
      <h2 class="text-4xl font-medium leading-tight text-gray-800">
        Amount:
        <span class="inline-block py-1.5 px-2.5 leading-none text-center whitespace-nowrap align-baseline font-bold bg-blue-600 text-white rounded"><%= number_to_currency(@amount) %></span>
      </h2>
    </div>
    """
  end
end
