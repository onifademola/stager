defmodule StagerWeb.SalesDashboardLive do
  use StagerWeb, :live_view

  alias Stager.Sales
  import Number.Currency
  import Number.Percentage

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign_stats(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign_stats(socket)}
  end

  def handle_event("refresh", _, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="p-6 shadow-lg rounded-lg bg-gray-100 text-white-400 flex space-x-40 justify-center">
        <div class="flex space-x-2 justify-center flex-col">
          <span>
            <h1 class="font-medium leading-tight text-5xl mt-0 mb-2 text-blue-600">
              <%= @new_orders %>
            </h1>
          </span>
          <p class="font-semibold mb-4">New Orders</p>
        </div>
        <div class="flex space-x-2 justify-center flex-col">
          <span>
            <h1 class="font-medium leading-tight text-5xl mt-0 mb-2 text-blue-600">
              <%= number_to_currency(@sales_amount, precision: 0) %>
            </h1>
          </span>
          <p class="font-semibold mb-4">Sales Amount</p>
        </div>
        <div class="flex space-x-2 justify-center flex-col">
          <span>
            <h1 class="font-medium leading-tight text-5xl mt-0 mb-2 text-blue-600">
              <%= number_to_percentage(@satisfaction, precision: 0) %>
            </h1>
          </span>
          <p class="font-semibold mb-4">Satisfaction</p>
        </div>
      </div>

      <button
        type="button"
        class="inline-block px-6 py-2.5 mt-4 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
        data-mdb-ripple="true"
        data-mdb-ripple-color="light"
        phx-click="refresh"
      >
        Refresh
      </button>
    </div>
    """
  end
end
