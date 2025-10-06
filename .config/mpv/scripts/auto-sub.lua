-- Select audio track containing "original" and subtitle track containing "ru"

local msg = require "mp.msg"

mp.register_event("file-loaded", function()
    local aid_list = mp.get_property_native("track-list")
    if not aid_list then return end

    local chosen_aid = 0
    local chosen_sid = 0

    for _, track in ipairs(aid_list) do
        if track.type == "audio" then
            local title = (track.title or ""):lower()
            local lang = (track.lang or ""):lower()
            if title:find("original") or lang:find("en") then
                chosen_aid = track.id
                mp.set_property_number("aid", chosen_aid)
            end
        elseif track.type == "sub" then
            local title = (track.title or ""):lower()
            local lang = (track.lang or ""):lower()
            if title:find("ru") or lang:find("ru") then
                chosen_sid = track.id
                mp.set_property_number("sid", chosen_sid)
            end
        end
    end
end)
