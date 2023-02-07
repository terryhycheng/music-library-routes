require "sinatra"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/album_repository"
require_relative "lib/artist_repository"
require_relative "lib/album"
require_relative "lib/artist"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "lib/album_repository"
    also_reload "lib/artist_repository"
  end

  get "/albums" do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:album_all)
  end

  get "/artists" do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artist_all)
  end

  get "/artists/new" do
    @title = "New Artist Form"
    @submit_to = "/artists"
    @fields = [{ name: "name", type: "text" }, { name: "genre", type: "text" }]
    return erb(:form)
  end

  get "/albums/new" do
    @title = "New Album Form"
    @submit_to = "/albums"
    @fields = [{ name: "title", type: "text" }, { name: "year", type: "text" }, { name: "artist_id", type: "number" }]
    return erb(:form)
  end

  get "/artists/:id" do
    artist_id = params[:id]
    repo = ArtistRepository.new
    @artist = repo.find(artist_id)
    return erb(:artist_one)
  end

  get "/albums/:id" do
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    album_id = params[:id]
    @album = album_repo.find(album_id)
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album_one)
  end

  post "/albums" do
    if invalid_album_request_params?
      status 400
      return ""
    end

    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(album)

    @type = "album"
    return erb(:created)
  end

  post "/artists" do
    if invalid_artist_request_params?
      status 400
      return ""
    end

    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]

    repo = ArtistRepository.new
    repo.create(artist)

    @type = "artist"
    return erb(:created)
  end

  private

  def invalid_artist_request_params?
    name = params[:name]
    genre = params[:genre]

    return true if name == nil || genre == nil
    return true if name == "" || genre == ""
  end

  def invalid_album_request_params?
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    return true if title == nil || release_year == nil || artist_id == nil
    return true if title == "" || release_year == "" || artist_id == ""
  end
end
