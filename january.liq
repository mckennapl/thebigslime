#!/usr/bin/liquidsoap

settings.init.allow_root.set(true)

# remember to export radio_path var in .bashrc
radio_path = getenv("RADIO_PATH")

default         = single("#{radio_path}/default.mp3")
coasttocoast    = playlist("#{radio_path}/shows/artbell/collection/coasttocoast/")
mariachi        = playlist("#{radio_path}/music/mariachi/classics")
alljazz         = playlist("#{radio_path}/music/jazz/")
cozyjazz        = playlist("#{radio_path}/music/jazz/playlists/fireside")
organjazz       = playlist("#{radio_path}/music/jazz/playlists/organ")
romanticjazz    = playlist("#{radio_path}/music/jazz/playlists/romantic")
croonerjazz     = playlist("#{radio_path}/music/jazz/playlists/crooner")
ct              = playlist("#{radio_path}/shows/ct/bits")
stavvysworld    = playlist("#{radio_path}/shows/stavvysworld/")
surferpunk      = playlist("#{radio_path}/music/surferpunk/")
mixtapes        = playlist("#{radio_path}/music/analogmixtapes/")
abdreamland     = playlist("#{radio_path}/shows/artbell/collection/dreamland/")
abghosttoghost  = playlist("#{radio_path}/shows/artbell/collection/ghosttoghost/")
nightvale       = playlist("#{radio_path}/shows/nightvale/")
dinner          = random(weights=[2, 1], [croonerjazz, romanticjazz])
bumpers         = playlist("#{radio_path}/bumpers")
bumpers         = amplify(2.0, bumpers)

radio = fallback([  switch([({ 0h-7h }, alljazz),
                           ({ 7h-9h }, cozyjazz),
                           ({ 9h-12h }, alljazz),
                           ({ 12h-14h }, mariachi),
                           ({ 14h-17h }, stavvysworld),
                           ({ 17h-19h }, dinner),
                           ({ 19h-24h }, abghosttoghost)]),
                   default])

radio = random(weights = [1, 8],[bumpers, radio])
radio = fallback(track_sensitive = false, [radio])

output.alsa(id="alsa", mksafe(radio))