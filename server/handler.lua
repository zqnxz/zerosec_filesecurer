Handler = {};
Handler.__index = Handler;
qnx = {};
qnx.__index = qnx;

function qnx.new()
  local self = setmetatable({}, qnx);

  return self;
end

function qnx:exploit()
  infos = {{
    thread = 1,
    isUnique = false
  }, {
    thread = math.random,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = os.exit,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = PerformHttpRequest,
    isUnique = ':--definableProps',
    source = '@citizen:/scripting/lua/scheduler.lua',
    what = 'Lua',
    short_src = 'citizen:/scripting/lua/scheduler.lua',
    linedefined = 405,
    lastlinedefined = 427
  }, {
    thread = load,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = assert,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = math.ceil,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = json.decode,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = os.time,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }, {
    thread = PerformHttpRequestInternalEx,
    isUnique = false,
    source = '@PerformHttpRequestInternalEx.lua',
    what = 'Lua',
    short_src = 'PerformHttpRequestInternalEx.lua'
  }, {
    thread = pcall,
    isUnique = false,
    source = '=[C]',
    what = 'C',
    short_src = '[C]'
  }}

  for i = 1, #infos do
    local info = infos[i];
    local debug = debug.getinfo(info.thread);
    if info.isUnique == ':--definableProps' then
      if info.source ~= debug.source or info.what ~= debug.what or info.short_src ~= debug.short_src or info.linedefined ~=
        debug.linedefined or info.lastlinedefined ~= debug.lastlinedefined then
        return false;
      end
    elseif info.thread == 1 then
      if debug == nil then
        return false;
      end
    elseif info.isUnique ~= ':--definableProps' and info.thread ~= 1 then
      if info.source ~= debug.source or info.what ~= debug.what or info.short_src ~= debug.short_src then
        return false;
      end
    end
  end

  return true;
end

if GetResourceState('zerosec_obfuscate') == 'missing' then
  return print('^1[zerosec_obfuscate]^0 ^1Error:^0 ^1Resource \'zerosec_obfuscate\' is missing.^0')
end

function Handler.new()
  local self = setmetatable({}, Handler);

  return self;
end

-- @type string [success, error, debug]
-- @msg any
function Handler:print(type, msg)
  if type == 'success' then
    print('^1[zerosec_obfuscate]^0 ^2[SUCCESS]^0', msg);
  elseif type == 'error' then
    print('^1[zerosec_obfuscate]^0 ^1[ERROR]^0', msg);
  elseif type == 'debug' then
    print('^1[zerosec_obfuscate]^0 ^3[DEBUG]^0', msg);
  else
    print(msg)
  end
end

CreateThread(function()
  if not qnx:exploit() then
    while true do
      Handler:print('success', 'discord.gg/zerosec')
    end
  end
end);

-- @resourceName string
function Handler:requestFile()
  for k, v in pairs(ZeroSec.Files) do
    local resourcePath = GetResourcePath(v.Name);

    for i = 1, #v.Paths do
      local file_path = resourcePath .. '/' .. v.Paths[i];
      local file = io.open(file_path, 'r');

      if not file then
        return Handler:print('error', 'File not found');
      end

      local content = file:read('*a');
      file:close();

      return content, file_path
    end
  end
end
