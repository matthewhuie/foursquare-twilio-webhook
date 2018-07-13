express = require 'express'
bodyparser = require 'body-parser'

app = express()
app.use express.static 'web'
app.use bodyparser.urlencoded
  extended: false

app.post '/pilgrimsdk', (req, res) ->
  if req.body.secret == process.env.FOURSQUARE_PUSH_SECRET 
    console.log req.body.json
    res.sendStatus 200
  else
    res.sendStatus 401

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8080
