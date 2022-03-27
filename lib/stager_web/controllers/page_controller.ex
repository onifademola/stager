defmodule StagerWeb.PageController do
  use StagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
