Common = {};
Common.__index = Common;

function Common.new()
  local self = setmetatable({}, Common);

  return self;
end

-- @resourceName string 
function Common:doesResourceExist(resourceName)
  local resources = GetNumResources();

  for i = 0, resources - 1 do
    local resource = GetResourceByFindIndex(i);

    if resource == resourceName then
      return true;
    end
  end

  return false;
end

-- @url string
-- @token any
function Common:makeRequest(url, token)

  for k, v in pairs(ZeroSec.Files) do
    local doesResourceExist = Common:doesResourceExist(v.Name);

    if not doesResourceExist then
      return Handler:print('error', 'Resource not found');
    end

    local files = Handler:requestFile();

    Handler:print('debug', 'Obfuscating script/s...');

    for i, s in pairs(files) do
      local success, error = pcall(function()
        Wait(2 * 1000)
        PerformHttpRequest(url, function(error, result, headers)
          local status, response = pcall(json.decode, result);
          local state = rawequal(status, true) or rawequal(response, true) or rawequal(response.script, true);

          if not state then
            return Handler:print('error', 'Invalid Script Code');
          end

          Wait(2 * 1000);

          local scriptContent = response.script;
          local serverFilePath = s.path;
          local serverFile = io.open(serverFilePath, 'w');

          serverFile:write(scriptContent);
          serverFile:close();

          Handler:print('success', 'Successfully obfuscated script/s');
        end, 'POST', json.encode({
          script = s.content,
          platformLock = v.Parameters.Body.platformLock,
          antiTamper = v.Parameters.Body.antiTamper,
          encryptStrings = v.Parameters.Body.encryptStrings,
          maxSecurity = v.Parameters.Body.maxSecurity,
          constantEncryption = v.Parameters.Body.constantEncryption,
          giveBackURL = v.Parameters.Body.giveBackURL
        }), {
          ['Content-Type'] = 'application/json',
          ['Authorization'] = token
        });
      end);
    end
  end
end

RegisterCommand('secure', function()
  Common:makeRequest('https://api.zero.sex/v1/obfuscate', ProtectedSettings.apiKey)
end);
