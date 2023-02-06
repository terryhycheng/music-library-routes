# Music Library Route Design Recipe

## Route Signature

| Method | Path    | Query | Body                           | Response          |
| ------ | ------- | ----- | ------------------------------ | ----------------- |
| GET    | /albums | -     | -                              | A list of records |
| POST   | /albums | -     | title, release_year, artist_id | -                 |

## Examples

### GET `/albums`

```
# Request:

Method: GET /albums

# Expected response:

Body: [<Album #001>, <Album #002>, <Album #003>]
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
