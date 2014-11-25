log = (require 'somata').helpers.log
Bacon = require 'baconjs'

# TODO: Build this into Somata
eventStream = (client, service, event, args...) ->
    Bacon.fromBinder (sink) ->
        client.on service, event, args..., (err, value, done) ->
            if done
                log.w "Ending stream"
                sink new Bacon.End()
            else
                log.d "Sinking value", value
                sink value
        onUnbind = -> log.s 'Ended?'
        return onUnbind

module.exports = eventStream

