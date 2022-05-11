defmodule StagerWeb.SearchLive do
  use StagerWeb, :live_view

  alias Stager.Stores

  def mount(_params, _session, socket) do
    {:ok, assign(socket, zip: "", stores: [], loading: false)}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    {:noreply, assign(socket, zip: zip, stores: [], loading: true)}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    case Stores.search_by_zip(zip) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{zip}\"")
          |> assign(stores: [], loading: false)
        {:noreply, socket}

      stores ->
        {:noreply, assign(socket, stores: stores, loading: false)}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-column justify-center px-6">
        <h3 class="font-medium leading-tight text-3xl">Find a Store</h3>
      </div>
      <div class="flex justify-center">
        <div class="mb-3 xl:w-96">
          <form phx-submit="zip-search">
            <div class="input-group relative flex flex-stretch items-stretch w-full mb-4">
              <input
                name="zip"
                type="search"
                class="form-control relative flex-auto min-w-0 block w-full px-3 py-1.5 text-base font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                placeholder="Zip search"
                aria-label="Zip"
                aria-describedby="button-addon2"
                value={@zip}
                readonly={@loading}
                />
              <button class="btn inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700  focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out flex items-center"
                type="button" id="button-addon2">
                <svg aria-hidden="true" focusable="false" data-prefix="fas" data-icon="search" class="w-4" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                  <path fill="currentColor" d="M505 442.7L405.3 343c-4.5-4.5-10.6-7-17-7H372c27.6-35.3 44-79.7 44-128C416 93.1 322.9 0 208 0S0 93.1 0 208s93.1 208 208 208c48.3 0 92.7-16.4 128-44v16.3c0 6.4 2.5 12.5 7 17l99.7 99.7c9.4 9.4 24.6 9.4 33.9 0l28.3-28.3c9.4-9.4 9.4-24.6.1-34zM208 336c-70.7 0-128-57.2-128-128 0-70.7 57.2-128 128-128 70.7 0 128 57.2 128 128 0 70.7-57.2 128-128 128z"></path>
                </svg>
              </button>
            </div>
          </form>
        </div>
      </div>
      <div>
        <%= if @loading do %>
          <div>Loading...</div>
        <% end %>
        <ul>
          <%= for store <- @stores do %>
            <li>
              <div class="first-line">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open">Open</span>
                  <% else %>
                    <span class="closed">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div>
                  <%= store.street %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
