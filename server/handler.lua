Handler = {};
Handler.__index = Handler;

if GetResourceState('zerosec_filesecurer') == 'missing' then
  return print('^1[zerosec_filesecurer]^0 ^1Error:^0 ^1Resource \'zerosec_obfuscate\' is missing.^0')
end

function Handler.new()
  local self = setmetatable({}, Handler);

  return self;
end

-- @type string [success, error, debug]
-- @msg any
function Handler:print(type, msg)
  if type == 'success' then
    print('^1[zerosec_filesecurer]^0 ^2[SUCCESS]^0', msg);
  elseif type == 'error' then
    print('^1[zerosec_filesecurer]^0 ^1[ERROR]^0', msg);
  elseif type == 'debug' then
    print('^1[zerosec_filesecurer]^0 ^3[DEBUG]^0', msg);
  else
    print(msg)
  end
end

-- @resourceName string
function Handler:requestFile()
  local results = {}

  for k, v in pairs(ZeroSec.Files) do
    local resourcePath = GetResourcePath(v.Name);

    for i = 1, #v.Paths do
      local file_path = resourcePath .. '/' .. v.Paths[i];
      local file = io.open(file_path, 'r');

      if not file then
        Handler:print('error', 'File not found');
      else
        local content = file:read('*a');
        file:close();

        table.insert(results, {
          content = content,
          path = file_path
        })
      end
    end
  end

  return results
end
