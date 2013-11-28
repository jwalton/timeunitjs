timeunit = require '../src/timeunit'
assert = require 'assert'

describe "timeunitjs", ->
    it "should do simple conversions", ->
        assert.equal 5000, timeunit.seconds.toMillis 5
        assert.equal 5, timeunit.milliseconds.toSeconds 5000

    it "should convert with convert() correctly", ->
        assert.equal 5000, timeunit.milliseconds.convert 5, timeunit.seconds
        assert.equal 5, timeunit.seconds.convert 5000, timeunit.milliseconds
