client = new (require('somata').Client)
eventStream = require 'somata-bacon'

getTime = -> new Date().getTime()
doBlink = (color) -> (t) -> client.remote 'blink', 'blink', color, t, 1

padBlink = ([pad, color]) ->

    ons = eventStream(client, 'midi', "nanoPAD2:#{ pad }:on")
    offs = eventStream(client, 'midi', "nanoPAD2:#{ pad }:off")

    ons.map(getTime).merge(offs.map(getTime)) # [t0, t1, t0, ...]
        .bufferWithCount(2)                   # [[t0, t1], ...]
        .map(([t0, t1]) -> t1 - t0)           # [dt, ...]
        .map(doBlink color)
        .log()

[[36, 'red'], [37, 'green'], [38, 'blue']].map padBlink

