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

  context "GET /albums" do
    it "returns 200 OK with a list of album names" do
      expected_ans = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
      res = get("/albums")

      expect(res.status).to eq 200
      expect(res.body).to eq(expected_ans)
    end
  end

  context "POST /albums" do
    it "returns 200 OK" do
      res = post("/albums", title: "Voyage", release_year: 2022, artist_id: 2)

      expect(res.status).to eq 200
    end
  end

  context "GET /artists" do
    it "returns 200 OK with a list of artist's names" do
      res = get("/artists")

      expect(res.status).to eq 200
      expect(res.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone"
    end
  end

  context "POST /artists" do
    it "returns 200 OK with an updated list of artists" do
      post_res = post("/artists", name: "Wild nothing", genre: "Indie")
      get_res = get("/artists")

      expect(post_res.status).to eq 200
      expect(get_res.status).to eq 200
      expect(get_res.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing"
    end
  end
end
