express = require 'express'
bodyparser = require 'body-parser'

app = express()
app.use express.static 'web'
app.use bodyparser.urlencoded
  extended: false

app.post '/twilio', (req, res) ->
  if req.body.AccountSid == process.env.TWILIO_ACCOUNT_SID
    console.log req.body.AccountSid
    res.sendStatus 200
  else
    res.sendStatus 401

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8080
