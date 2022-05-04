defmodule Stager.TeachersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Stager.Teachers` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Stager.Teachers.create_post()

    post
  end
end
