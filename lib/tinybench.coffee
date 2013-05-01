class TinyBench

  constructor: (numRuns, benchmarks) ->
    @report = {}
    @benchmarks = benchmarks

    @run(numRuns)
    @computeStats()

  getReport: -> @report

  # Run all benchmarks `n` number of times
  run: (n) ->
    @init(benchName) for benchName, method of @benchmarks

    for run in [0...n]
      for benchName, method of @benchmarks

        startTime = @hTime()

        method()
        @appendRun(benchName, startTime)

  # Compute all run statistics and put them into `@report`
  computeStats: ->
    for benchName of @report
      r = @report[benchName]
      r.total = r.runs.reduce( ((memo, n) -> memo + n ), 0)
      r.average = r.total / r.runs.length
      r.max = r.runs.reduce( ((memo, n) -> if n > memo then n else memo ), -Infinity)
      r.min = r.runs.reduce( ((memo, n) -> if n < memo then n else memo ), Infinity)

  # Initialize a given method `key` for reporting
  init: (key) ->
    @report[key] =
      runs: []

  hTime: ->
    hrtime = process.hrtime()
    ((hrtime[0] * 1e9 + hrtime[1]) / 1000000)

  # Mark a given key's time as finished while noting the `startTime`
  appendRun: (key, startTime) ->
    endTime = @hTime()
    @report[key].runs.push( endTime - startTime )

module.exports = TinyBench