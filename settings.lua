ZeroSec = {
  Files = {{
    ['Name'] = 'zerosec_filesecurer',
    ['Paths'] = {'server/test.lua', 'server/affen.lua'}, -- files to obfuscate

    Parameters = {
      ['Body'] = {
        ['script'] = '', -- leave it default !!!DO NOT TOUCH!!!
        ['platformLock'] = 'lua',
        ['antiTamper'] = true,
        ['encryptStrings'] = true,
        ['maxSecurity'] = true,
        ['constantEncryption'] = true,
        ['giveBackURL'] = false
      }
    }
  }}
}

-- Header --
-- @Authorization String Your zeroSec API-Key.

-- Body --
-- @script String The Lua script which will be obfuscated
-- @platformLock String The Platform you want to obfuscate your script for. Supported: lua, roblox, csgo, fivem
-- @antiTamper Boolean Prevents tampering with the script. Your environment will need to support loadstring or load
-- @encryptStrings Boolean Encrypt strings in the script, performance will be affected (not recommended).
-- @maxSecurity Boolean Maximises security at the cost of performance
-- @constantEncryption Boolean Prevents constants from getting dumped easily
-- @giveBackURL Boolean Wheter if you get a URL back in the response or not
