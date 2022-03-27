defmodule Stager.Repo do
  use Ecto.Repo,
    otp_app: :stager,
    adapter: Ecto.Adapters.Postgres
end
