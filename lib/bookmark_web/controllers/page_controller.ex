defmodule BookmarkWeb.PageController do
  use BookmarkWeb, :controller
  alias Bookmark.{Repo, Shortcode, Helpers}
  import Ecto.Query

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      bookmark: Repo.all(from(b in Shortcode))
    )
  end

  def delete(conn, params) do
    user_id = conn.assigns.current_user.id
    ptbd = Repo.get(Shortcode, params["to_be_deleted"])

    if ptbd.created_by == user_id do
      query = Repo.get_by(Shortcode, id: params["to_be_deleted"])
      Repo.delete(query)
    else
      conn
      |> put_flash(:error, "Don't touch that it's not yours to delete.")
      |> redirect(to: "/")
    end

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def create(conn, params) do
    IO.inspect(conn.assigns.current_user.id, label: "user id")

    code = Helpers.generate()
    user_id = conn.assigns.current_user.id

    %Shortcode{}
    |> Shortcode.changeset(%{"url" => params["url"], "code" => code, "created_by" => user_id})
    |> Repo.insert()

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def redirector(conn, params) do
    url = Helpers.code_to_url(params["page"])
    redirect(conn, external: url.url)
  end
end
