dcopy = (t) ->
  tt = {}
  for k,v in pairs t
    tt[dcopy(k)] = dcopy(v)
  return tt

standardConfig =
  scriptLocation: "/themis/"

config = dcopy standardConfig

if fs.exists ".themis"
  handle = fs.open ".themis", "r"
  content = handle.readAll!
  handle.close!
  config = loadstring("return " .. content)()

routines = {}

addRoutine = (f) ->
  routines[#routines+1] =
    routine: coroutine.create f
    active: true
    filter: nil
  #routines

for k,v in pairs fs.list config.scriptLocation
  handle = fs.open (fs.combine config.scriptLocation, v), "r"
  content = handle.readAll!
  handle.close!
  addRoutine loadstring(content)

while true
  evt = {coroutine.yield!}
  for k,v in pairs routines
    if v.filter == evt[1] or v.filter == nil or evt[1] == "terminate"
      if coroutine.status(v.routine) != "dead"
        ok, v.filter = coroutine.resume(v.routine, unpack evt)
