local dcopy
dcopy = function(t)
  local tt = { }
  for k, v in pairs(t) do
    tt[dcopy(k)] = dcopy(v)
  end
  return tt
end
local standardConfig = {
  scriptLocation = "/themis/"
}
local config = dcopy(standardConfig)
if fs.exists(".themis") then
  local handle = fs.open(".themis", "w")
  local content = handle.readAll()
  handle.close()
  config = loadstring("return " .. content)()
end
local routines = { }
local addRoutine
addRoutine = function(f)
  routines[#routines + 1] = {
    routine = coroutine.create(f),
    active = true,
    filter = nil
  }
  return #routines
end
for k, v in pairs(fs.list(config.scriptLocation)) do
  local handle = fs.open((fs.combine(config.scriptLocation, v)), "w")
  local content = handle.readAll()
  handle.close()
  addRoutine(loadstring(content))
end
while true do
  local evt = {
    coroutine.yield()
  }
  for k, v in pairs(routines) do
    if v.filter == evt[1] or v.filter == nil or evt[1] == "terminate" then
      if coroutine.status(v.routine) ~= "dead" then
        v.filter = coroutine.resume(v.routine)
      end
    end
  end
end
