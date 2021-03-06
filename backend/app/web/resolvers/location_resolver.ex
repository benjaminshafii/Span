defmodule App.LocationResolver do
  alias App.Repo
  alias App.Location
  import Ecto.Query, only: [where: 2]

  def all(_args, %{context: %{current_user: %{id: id}}}) do
    locations =
      Location
      |> where(user_id: ^id)
      |> Repo.all
    {:ok, locations}
  end

  def all(_args, _info) do
    {:error, "Not authorized"}
  end

  def create(args, %{context: %{current_user: %{id: id}}}) do
    %Location{}
    |> Location.changeset(args, id)
    |> Repo.insert
  end

  def delete(%{id: id}, _info) do
    location = Repo.get!(Location, id)
    Repo.delete(location)
  end

  def update(%{id: id, location: location_params}, %{context: %{current_user: %{id: user_id}}}) do
    Location
    |> where(user_id: ^user_id)
    |> Repo.get(id)
    |> Location.changeset(location_params, user_id)
    |> Repo.update
  end
end
