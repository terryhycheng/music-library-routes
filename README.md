# Test-driving Music Library Routes

This challenge asks me to create CRUD routes with TDD.

- [Test-driving Music Library Routes](#test-driving-music-library-routes)
  - [Route Signature](#route-signature)
  - [Examples](#examples)
    - [GET `/albums`](#get-albums)
    - [GET `/artists`](#get-artists)
    - [POST `/albums`](#post-albums)
    - [POST `/artists`](#post-artists)
  - [Diagram](#diagram)
    - [POST `/artists`](#post-artists-1)

## Route Signature

| Method | Path     | Query | Body                           | Response          |
| ------ | -------- | ----- | ------------------------------ | ----------------- |
| GET    | /albums  | -     | -                              | A list of records |
| GET    | /artists | -     | -                              | A list of artists |
| POST   | /albums  | -     | title, release_year, artist_id | -                 |
| POST   | /artists | -     | name, genre                    | -                 |

## Examples

### GET `/albums`

```
# Request:

Method: GET /albums

# Expected response:

Body: "Doolittle, Surfer Rosa, ...Ring Ring"
Status: Response for 200 OK

```

### GET `/artists`

```
# Request:
GET /artists

# Expected response
Body: Pixies, ABBA, Taylor Swift, Nina Simone
Status: Response for 200 OK
```

### POST `/albums`

```
# Request:

Method: POST /albums
Body: { title: "Voyage", release_year: 2022, artist_id: 2 }

# Expected response:

Status: Response for 200 OK
```

### POST `/artists`

```
# Request:
POST /artists

# With body parameters:
name=Wild nothing
genre=Indie

# Expected response (200 OK)
(No content)

# Then subsequent request:
GET /artists

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing
```

## Diagram

### POST `/artists`

![post-artists-diagram](assets/diagram.png)
