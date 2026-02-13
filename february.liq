#!/usr/bin/liquidsoap

settings.init.allow_root.set(true)

# remember to export radio_path var in .bashrc
radio_path = environment.get(default="/radio/depot", "RADIO_PATH")

# radio identification
default         = single("#{radio_path}/default.mp3")

# country collections
johnnycashradio = playlist("#{radio_path}/music/country/johnnycashradio")
banjo_202602    = playlist("#{radio_path}/music/country/mountainbanjo-202602")


# funk collections
funk            = playlist("#{radio_path}/music/funk/classics")

# jazz collections
alljazz         = playlist("#{radio_path}/music/jazz/")
cozyjazz        = playlist("#{radio_path}/music/jazz/playlists/fireside")
organjazz       = playlist("#{radio_path}/music/jazz/playlists/organ")
romanticjazz    = playlist("#{radio_path}/music/jazz/playlists/romantic")
croonerjazz     = playlist("#{radio_path}/music/jazz/playlists/crooner")
cooking_202602  = playlist("#{radio_path}/music/jazz/playlists/jazzycooking-202602")

# mariachi collections
mariachi        = playlist("#{radio_path}/music/mariachi/classics")
thebronx        = playlist("#{radio_path}/music/mariachi/thebronx")


# podcasts
nightvale       = playlist("#{radio_path}/shows/nightvale/")

# podcast clips
ct              = playlist("#{radio_path}/shows/ct/bits")
stavvysworld    = playlist("#{radio_path}/shows/stavvysworld/")

# punk collections
surferpunk      = playlist("#{radio_path}/music/punk/surfer")
bayside         = playlist("#{radio_path}/music/punk/bayside")
joyce         = playlist("#{radio_path}/music/punk/joyce")

# vinyl sets (usually 45-60 mins)
mixtapes        = playlist("#{radio_path}/music/analogmixtapes/")

# rotating daily mixes
top40_202601    = playlist("#{radio_path}/music/top40/top40-202601")
top40_202602    = playlist("#{radio_path}/music/top40/top40-202602")

# art bell collections
abdreamland     = playlist("#{radio_path}/shows/artbell/collection/dreamland/")
abghosttoghost  = playlist("#{radio_path}/shows/artbell/collection/ghosttoghost/")
coasttocoast    = playlist("#{radio_path}/shows/artbell/collection/coasttocoast/")

# playlist combos
dinner          = random(weights=[2, 1], [croonerjazz, romanticjazz, cooking_202602])

# bumpers
bumpers         = playlist("#{radio_path}/bumpers")
bumpers         = amplify(2.0, bumpers)


# schedule
radio = fallback([  switch([({ 0h-5h }, mixtapes),
                           ({ 5h-9h }, cozyjazz),
                           ({ 9h-12h }, alljazz),
                           ({ 12h-13h }, thebronx),
                           ({ 13h-14h }, bayside),
                           ({ 14h-16h }, top40_202602),
                           ({ 16h-17h }, joyce),
                           ({ 17h-19h }, dinner),
                           ({ 19h-21h }, johnnycashradio),
                           ({ 21h-24h }, banjo_202602)]),
                   default])

radio = random(weights = [1, 8],[bumpers, radio])
radio = fallback(track_sensitive = false, [radio])
radio = normalize(radio)
radio = buffer(radio)
output.alsa(id="alsa", mksafe(radio))