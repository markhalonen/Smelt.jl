# Smelt.jl
Julia client for Smelt.jl

# About Smelt

Smelt helps software development teams monitor their sensitive resources. These resources can include runtime, memory, api usage, function calls, and the like.

Smelt provides a simple API:

- `name`: The name of your metric
- `value`: The value of the metric
- (Optional) `write`: Defaults to `false`, determines if data is saved permanently to Smelt
- (Optional) `date`: The date of the metric (defaults to now)


## Examples

### Tracking runtime

#### Source Code

```julia
function performance_function()
# Lots of code, we want to know when performance changes. And we want history of performance
end
```

#### Test Code

```julia
function test_performance_function()
  start_time = now()
  performance_function()
  end_time = now()
  result = Smelt.send("Performance function runtime", end_time - start_time)
  if result.isabnormal
    fail("Smelt detected an abnormality! See $(result.link) for details")
  end
end
```

### Tracking usage of an expensive api

#### Source Code
```julia
function call_expensive_api() end
end

function do_complex_workflow()
...
# Lots of code that calls `call_expensive_api` some number of times, which we'd like to track
end
```

#### Test Code

We're going to mock `call_expensive_api` and count the number of times it is called, and log to Smelt
```julia
function test_expensive_api_usage_in_complex_workflow()
  api_mock = mock(call_expensive_api)
  do_complex_workflow()
  result = Smelt.send("Expensive API Calls From Complex Workflow", api_mock.call_count)
  if result.isabnormal
    fail("Smelt detected an abnormality! See $(result.link) for details.")
  end
end
```


Things to consider
- Data shouldn't always get saved, for example running locally or from a PR.
- Could make it aware of the hardware it's running on.


Steps a user needs to take:
1. Register account and get API key
2. Include open-source client library to project
3. Write tests 
4. Intelligently confiure when data should get written permanently to Smelt. It should only `write` when it's the __master branch running on the build server__.
5. Visit the Smelt web app and configure anomaly thresholds



