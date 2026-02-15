#!/usr/bin/liquidsoap

settings.init.allow_root.set(true)

# remember to export radio_path var in .bashrc
radio_path = environment.get(default="/radio/depot", "RADIO_PATH")

# radio identification
default         = single("#{radio_path}/default.mp3")

# vinyl sets (usually 45-60 mins)
mixtapes        = playlist("#{radio_path}/music/analogmixtapes/")

# decades
80s_gems        = playlist("#{radio_path}/music/decades/80s/hiddengems-022026")

# mariachi collections
mariachi        = playlist("#{radio_path}/music/mariachi/classics")

# jazz
bigband         = playlist("#{radio_path}/music/jazz/playlists/bigband-202602")
organjazz       = playlist("#{radio_path}/music/jazz/playlists/organ")

# halloween party
halloween       = playlist("#{radio_path}/music/holiday/halloween/kids")

# country
westernswing    = playlist("#{radio_path}/music/country/wswing_022026")
mountainbanjo   = playlist("#{radio_path}/music/country/mountainbanjo-202602")

# schedule
radio = fallback([  switch([({ 0h-5h }, mixtapes),
                           ({ 5h-10h }, organjazz),
                           ({ 10h-14h }, halloween),
                           ({ 14h-16h }, 80s_gems),
                           ({ 16h-17h }, westernswing),
                           ({ 17h-21h }, bigband)
                           ({ 21h-24h }, mountainbanjo)]),
                   default])

radio = random(weights = [1, 8],[bumpers, radio])
radio = fallback(track_sensitive = false, [radio])
radio = normalize(radio)

output.alsa(id="alsa", mksafe(radio))
