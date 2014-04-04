# Simple EventEmitter for the client
# Adapted from https://github.com/arunoda/meteor-streams/blob/master/lib/ev.js

class EventEmitter
  constructor: ->
    @handlers = {}

  emit: (event) ->
    args = Array::slice.call(`arguments`, 1)
    handler.apply(@, args) for handler in @handlers[event] if @handlers[event]
    return

  on: (event, callback) ->
    @handlers[event] = [] unless @handlers[event]
    @handlers[event].push(callback)
    return

  once: (event, callback) ->
    @on event, onetimeCallback = ->
      callback.apply(@, `arguments`)
      @removeListener(event, onetimeCallback)
      return
    return

  removeListener: (event, callback) ->
    if @handlers[event]
      index = @handlers[event].indexOf(callback)
      @handlers[event].splice(index, 1)
    return

  removeAllListeners: (event) ->
    @handlers[event] = `undefined`
    return
