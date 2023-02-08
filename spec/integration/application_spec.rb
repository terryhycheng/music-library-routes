require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    albums_seeds_sql = File.read("spec/seeds/albums_seeds.sql")
    artists_seeds_sql = File.read("spec/seeds/artists_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(albums_seeds_sql)
    connection.exec(artists_seeds_sql)
  end

  context "GET /" do
    it "returns 200 OK with correct contents" do
      res = get("/")

      expect(res.body).to include("<h1>Welcome to Terry's Music Library!</h1>")
      expect(res.body).to include("<h2>What do you want to browse?</h2>")
      expect(res.body).to include("<a href=\"/albums\">")
      expect(res.body).to include("<a href=\"/artists\">")
    end
  end

  context "GET /albums" do
    it "returns 200 OK with a list of album names" do
      res = get("/albums")

      expect(res.body).to include("<h1>Albums</h1>")
      expect(res.body).to include("<div>")
      expect(res.body).to include("Doolittle")
      expect(res.body).to include("Here Comes the Sun")
      expect(res.body).to include("Ring Ring")
    end
  end

  context "POST /albums" do
    it "returns 200 OK" do
      res = post("/albums", title: "Voyage", release_year: 2022, artist_id: 2)

      expect(res.status).to eq 200
      expect(res.body).to include "Your album has been created!"
    end
  end

  context "POST /artists" do
    it "returns 200 OK" do
      res = post("/artists", name: "Shawn Mendes", genre: "Pop")

      expect(res.status).to eq 200
      expect(res.body).to include "Your artist has been created!"
    end
  end

  context "GET /artists" do
    it "returns 200 OK with a list of artist's names" do
      res = get("/artists")

      expect(res.status).to eq 200
      expect(res.body).to include "<h1>Artists</h1>"
      expect(res.body).to include "<div>"
      expect(res.body).to include "Pixies"
      expect(res.body).to include "Taylor Swift"
      expect(res.body).to include "Nina Simone"
    end
  end

  context "GET /artists/:id" do
    it "returns 200 OK with the details of Pixies (id: 1)" do
      res = get("/artists/1")

      expect(res.body).to include "<h1>"
      expect(res.body).to include "<p>"
      expect(res.body).to include "Pixies"
      expect(res.body).to include "Rock"
    end

    it "returns 200 OK with the details of Taylor Swift (id: 3)" do
      res = get("/artists/3")

      expect(res.body).to include "<h1>"
      expect(res.body).to include "<p>"
      expect(res.body).to include "Taylor Swift"
      expect(res.body).to include "Pop"
    end
  end

  context "GET /albums/:id" do
    it "returns 200 OK with the details of Doolittle (id: 1)" do
      res = get("albums/1")

      expect(res.body).to include("<h1>")
      expect(res.body).to include("<p>")
      expect(res.body).to include("Doolittle")
      expect(res.body).to include("Release year: 1989")
      expect(res.body).to include("Artist: Pixies")
    end

    it "returns 200 OK with the details of Surfer Rosa (id: 2)" do
      res = get("albums/2")

      expect(res.body).to include("<h1>")
      expect(res.body).to include("<p>")
      expect(res.body).to include("Surfer Rosa")
      expect(res.body).to include("Release year: 1988")
      expect(res.body).to include("Artist: Pixies")
    end
  end

  context "POST /artists" do
    it "returns 200 OK with an updated list of artists" do
      post_res = post("/artists", name: "Wild nothing", genre: "Indie")
      get_res = get("/artists")

      expect(post_res.status).to eq 200
      expect(get_res.status).to eq 200
      expect(get_res.body).to include "Wild nothing"
    end
  end

  context "GET /albums/new" do
    it "returns 200 and shows a form correctly" do
      res = get("/albums/new")

      expect(res.body).to include("<h1>New Album Form</h1>")
      expect(res.body).to include("<form action=\"/albums\" method=\"POST\">")
    end
  end

  context "GET /artists/new" do
    it "returns 200 and shows a form correctly" do
      res = get("/artists/new")

      expect(res.body).to include("<h1>New Artist Form</h1>")
      expect(res.body).to include("<form action=\"/artists\" method=\"POST\">")
    end
  end
end
