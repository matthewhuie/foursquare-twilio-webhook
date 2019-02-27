express = require 'express'
bodyparser = require 'body-parser'
request = require 'request'
_ = require 'underscore'
MessagingResponse = require('twilio').twiml.MessagingResponse

app = express()
app.use express.static 'web'
app.use bodyparser.urlencoded
  extended: false

app.post '/twilio', (req, res) ->
  if req.body.AccountSid == process.env.TWILIO_ACCOUNT_SID
    input = req.body.Body
    separator = input.lastIndexOf ' in '

    if separator != -1
      twiml = new MessagingResponse()
      qs =
        client_id: process.env.FOURSQUARE_CLIENT_ID
        client_secret: process.env.FOURSQUARE_CLIENT_SECRET
        v: '20180101'
        query: input.substring 0, separator
        near: input.substring separator + 4 
        limit: 3 

      request
        url: 'https://api.foursquare.com/v2/search/recommendations'
        qs: qs
        callback: (error, response, body) ->
          data = JSON.parse body
          results = _.map data.response.group.results, (result) ->
            result.venue.name + ' - ' + result.venue.location.address + ' - https://foursquare.com/v/' + result.venue.id

          twiml.message results.join '\n'
          res.writeHead 200, 
            'Content-Type': 'text/xml'
          res.end twiml.toString()
    else
      res.sendStatus 500
  else
    res.sendStatus 401

app.use (req, res) ->
  res.sendStatus 404

app.listen process.env.PORT or 8080
