# Saying lol is the less cool thing evar
# @autor Frederick Dubois
# t: @frederickdubois
# http://duprogrammeur.com
#


module.exports = (robot) ->

  words = [
    'lol',
    'l.o.l.',
    'lolz'
  ]
  
  messages = [
  "C'mon... LOL is the uncoolest thing you could say. Evar!",
  "Shame! LOL == wrong.",
  "Focus!",
  "Work plz."
  ]
  regex = new RegExp('(?:^|\\s)(' + words.join('|') + ')(?:\\s|\\.|\\?|!|$)', 'i');

  robot.hear regex, (msg) ->
    msg.send msg.random messages
