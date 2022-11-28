local utils = require 'mp.utils'
local msg = require 'mp.msg'

local function get_clipboard()
    local res = utils.subprocess({ args = {
        'powershell', '-NoProfile', '-Command', [[& {
            Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }

            $clip = ""
            if (Get-Command "Get-Clipboard" - errorAction SilentlyContinue) {
                $clip = Get-Clipboard -Raw -Format Text -TextFormatType UnicodeText
            } else {
                Add-Type -AssemblyName PresentationCore
                $clip = [Windows.Clipboard]::GetText()
            }

            $clip = $clip -replace "`r",""
            $u8clip = [System.Text.Encoding]::UTF8.GetBytes($clip)
            [Console]::OpenStandardOutput().Write($u8clip, 0, $u8clip.Length)
        }]]
    } })
    if not res.error then
        return res.stdout
    end
    return ''
end

mp.add_key_binding("ctrl+v", "paste", function()
    local text = get_clipboard()
    if (text:find("https?://") == 1) then
        mp.commandv('loadfile', text, 'append-play')
    end
end)

local function set_clipboard(text)
    local res = utils.subprocess({ args = {
        'powershell', '-NoProfile', '-Command', string.format([[& {
            Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }
            Add-Type -AssemblyName PresentationCore
            [System.Windows.Clipboard]::SetText('%s')
        }]], text)
    } })
end

mp.add_key_binding("ctrl+c", "copy", function()
    local text = mp.get_property_native('path', '')
    if (text:find("https?://") == 1) then
        local time = math.floor(mp.get_property_number('time-pos'))
        set_clipboard(text..'&t='..tostring(time))
    end
end)

mp.add_key_binding("ctrl+C", "copy-wo-time", function()
    local text = mp.get_property_native('path', '')
    if (text:find("https?://") == 1) then
        set_clipboard(text)
    end
end)