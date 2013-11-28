# Port of [Doug Lea](http://g.oswego.edu/)'s public domain Java TimeUnit class to JavaScript.
#
# Based on the [backport-util-concurrent](http://backport-jsr166.sourceforge.net/) version.
# Ported by Jason Walton, released under the
# [public domain](http://creativecommons.org/licenses/publicdomain).
#

# A `TimeUnit` represents time durations at a given unit of
# granularity and provides utility methods to convert across units,
# and to perform timing and delay operations in these units.  A
# `TimeUnit` does not maintain time information, but only
# helps organize and use time representations that may be maintained
# separately across various contexts.  A nanosecond is defined as one
# thousandth of a microsecond, a microsecond as one thousandth of a
# millisecond, a millisecond as one thousandth of a second, a minute
# as sixty seconds, an hour as sixty minutes, and a day as twenty four
# hours.
#
# A `TimeUnit` is mainly used to inform time-based methods
# how a given timing parameter should be interpreted.  Time units may be passed as constants
# to other methods:
#
#     wait(50, timeunit.seconds);
#
# Or can be used to perform conversions, such as converting 5 seconds into 5000 milliseconds:
#
#     timeunit.seconds.toMilliseconds(5); # Returns 5000
#     timeunit.milliseconds.convert(5, timeunit.seconds); # Returns 5000
#
# We also define the very handy `sleep()` function, which schedules a function for future
# execution using `setTimeout()`:
#
#     timeunit.seconds.sleep(5, function() {
#         console.log("Hello after 5 seconds!");
#     });
#

# Based on https://github.com/umdjs/umd/blob/master/returnExports.js
umd = (root, factory) ->
    if typeof define is 'function' and define.amd
        # AMD. Register as an anonymous module.
        define([], factory)
    else if typeof exports is 'object' and typeof module is 'object'
        # Node. Does not work with strict CommonJS, but
        # only CommonJS-like enviroments that support module.exports,
        # like Node.
        module.exports = factory();
    else
        # Browser globals (root is window)
        root.timeunit = factory(root.b);

umd this, ->
    exports = {}

    # Create new objects.  `proto` is the parent to inherit from, `newObj` is the new
    # object definition.
    object = (proto, newObj) ->
        console.log proto
        console.log newObj
        if Object.create?
            answer = Object.create proto
        else
            F = ->
            F.prototype = proto
            answer = new F()

        # Add properties from newObj.
        for name, prop of newObj
            answer[name] = prop

        return answer


    # Handy constants for conversion methods
    C0 = 1
    C1 = C0 * 1000
    C2 = C1 * 1000
    C3 = C2 * 1000
    C4 = C3 * 60
    C5 = C4 * 60
    C6 = C5 * 24

    MAX = 9007199254740992

    # Scale d by m, checking for overflow.
    # This has a short name to make code below more readable.
    x = (d, m, over) ->
        if (d >  over) then return 9007199254740992
        if (d < -over) then return -9007199254740992
        return d * m

    # Base from which all our constants inherit.
    baseTimeUnit = {
        # Call `done` after the specified timeout.
        sleep: (timeout, done) ->
            if (timeout > 0)
                ms = @toMillis timeout
                setTimeout done, ms
            else
                done()
    }

    exports.nanoseconds = object baseTimeUnit, {
        index: 0
        name: "nanoseconds"
        toNanos:   (d) -> d
        toMicros:  (d) -> d/(C1/C0)
        toMillis:  (d) -> d/(C2/C0)
        toSeconds: (d) -> d/(C3/C0)
        toMinutes: (d) -> d/(C4/C0)
        toHours:   (d) -> d/(C5/C0)
        toDays:    (d) -> d/(C6/C0)
        convert:   (d, unit) -> unit.toNanos d
    }

    exports.microseconds = object baseTimeUnit, {
        index: 1
        name: "microseconds"
        toNanos:   (d) -> x(d, C1/C0, MAX/(C1/C0))
        toMicros:  (d) -> d
        toMillis:  (d) -> d/(C2/C1)
        toSeconds: (d) -> d/(C3/C1)
        toMinutes: (d) -> d/(C4/C1)
        toHours:   (d) -> d/(C5/C1)
        toDays:    (d) -> d/(C6/C1)
        convert:   (d, unit) -> unit.toMicros d
    }

    exports.milliseconds = object baseTimeUnit, {
        index: 2
        name: "milliseconds"
        toNanos:   (d) -> x(d, C2/C0, MAX/(C2/C0))
        toMicros:  (d) -> x(d, C2/C1, MAX/(C2/C1))
        toMillis:  (d) -> d
        toSeconds: (d) -> d/(C3/C2)
        toMinutes: (d) -> d/(C4/C2)
        toHours:   (d) -> d/(C5/C2)
        toDays:    (d) -> d/(C6/C2)
        convert:   (d, unit) -> unit.toMillis d
    }

    exports.seconds = object baseTimeUnit, {
        index: 3
        name: "seconds"
        toNanos:   (d) -> x(d, C3/C0, MAX/(C3/C0))
        toMicros:  (d) -> x(d, C3/C1, MAX/(C3/C1))
        toMillis:  (d) -> x(d, C3/C2, MAX/(C3/C2))
        toSeconds: (d) -> d
        toMinutes: (d) -> d/(C4/C3)
        toHours:   (d) -> d/(C5/C3)
        toDays:    (d) -> d/(C6/C3)
        convert:   (d, unit) -> unit.toSeconds d
    }

    exports.minutes = object baseTimeUnit, {
        index: 4
        name: "minutes"
        toNanos:   (d) -> x(d, C4/C0, MAX/(C4/C0))
        toMicros:  (d) -> x(d, C4/C1, MAX/(C4/C1))
        toMillis:  (d) -> x(d, C4/C2, MAX/(C4/C2))
        toSeconds: (d) -> x(d, C4/C3, MAX/(C4/C3))
        toMinutes: (d) -> d
        toHours:   (d) -> d/(C5/C4)
        toDays:    (d) -> d/(C6/C4)
        convert:   (d, unit) -> unit.toMinutes d
    }

    exports.hours = object baseTimeUnit, {
        index: 5
        name: "hours"
        toNanos:   (d) -> x(d, C5/C0, MAX/(C5/C0))
        toMicros:  (d) -> x(d, C5/C1, MAX/(C5/C1))
        toMillis:  (d) -> x(d, C5/C2, MAX/(C5/C2))
        toSeconds: (d) -> x(d, C5/C3, MAX/(C5/C3))
        toMinutes: (d) -> x(d, C5/C4, MAX/(C5/C4))
        toHours:   (d) -> d
        toDays:    (d) -> d/(C6/C5)
        convert:   (d, unit) -> unit.toHours d
    }

    exports.days = object baseTimeUnit, {
        index: 6
        name: "days"
        toNanos:   (d) -> x(d, C6/C0, MAX/(C6/C0))
        toMicros:  (d) -> x(d, C6/C1, MAX/(C6/C1))
        toMillis:  (d) -> x(d, C6/C2, MAX/(C6/C2))
        toSeconds: (d) -> x(d, C6/C3, MAX/(C6/C3))
        toMinutes: (d) -> x(d, C6/C4, MAX/(C6/C4))
        toHours:   (d) -> x(d, C6/C5, MAX/(C6/C5))
        toDays:    (d) -> d
        convert:   (d, unit) -> unit.toDays d
    }

    exports.values = [
        exports.nanoseconds
        exports.microseconds
        exports.milliseconds
        exports.seconds
        exports.hours
        exports.days
    ]

    return exports

