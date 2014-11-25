log = (require 'somata').helpers.log
Bacon = require 'baconjs'

# TODO: Build this into Somata
eventStream = (client, service, event, args...) ->
    Bacon.fromBinder (sink) ->
        client.on service, event, args..., (err, value, done) ->
            if done
                log.w 'Ending stream...'
                sink new Bacon.End()
            else
                sink value
        onUnbind = -> log.s 'Stream ended.'
        return onUnbind

module.exports = eventStream

