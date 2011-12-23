# Note in Hubot what you want him to learn in the future
# Keep track of the hooks you want to add to it as a team.
#
# learn to <learning> - Add something you wish your Hubot could do
# learnings list - List the things your Hubot has to learn to satisfy his masters
# you learned <learning number> - Mark item # as learned in the list
# learned list - List the things your Hubot has learned and that were on his list.
# forget to learn <learning number> - Delete this item from the list
# 
# @autor Frederick Dubois
# t: @frederickdubois
# http://duprogrammeur.com
#
# @disclaimer I must admit I used task.coffee as a kickstarter for this script. :)
# 
# @todo : seems like there is a problem with the brain. Lists are emptying after restard... need to find a way to make them persistent.

class Learnings
  constructor: (@robot) ->
    @cache = []
    @cacheLearned = []
    @robot.brain.on 'loaded',   =>
      if @robot.brain.data.learnings
        @cache = @robot.brain.data.learnings
      if @robot.brain.data.learnedthings
        @cacheLearned = @robot.brain.data.learnedthings
  nextNum: (cachedList) ->
    maxNum = if cachedList.length then Math.max.apply(Math,cachedList.map (n) -> n.num) else 0
    maxNum++
    maxNum 
  add: (learnString) ->
    learn = {num: @nextNum(@cache), learn: learnString}
    @cache.push learn
    @robot.brain.data.learnings = @cache
    learn
  addLearned: (learnString) ->
    learn = {num: @nextNum(@cacheLearned), learn: learnString}
    @cacheLearned.push learn
    @robot.brain.data.learnedthings = @cacheLearned
    learn
  all: -> @cache
  allLearned: -> @cacheLearned
  deleteByNumber: (num) ->
    index = @cache.map((n) -> n.num).indexOf(parseInt(num))
    learn = @cache.splice(index, 1)[0]
    @robot.brain.data.learnings = @cache
    learn

module.exports = (robot) ->
  learnings = new Learnings robot

  robot.respond /(learn to|learn|plz learn|plz learn to) (.+?)$/i, (msg) ->
    learn = learnings.add msg.match[2]
    msg.send "Ok Boss, added this to my list of things to learn: ##{learn.num} - #{learn.learn}"

  robot.respond /(learnings list|learnings|list learnings)/i, (msg) ->
    if learnings.all().length > 0
      response = ""
      for learn, num in learnings.all()
        response += "##{learn.num} - #{learn.learn}\n"
      msg.send response
    else
      msg.send "Eh Boss, I have nothing more to learn. Student > Master. =P"
  
  robot.respond /(learned list)/i, (msg) ->
    if learnings.allLearned().length > 0
      response = ""
      for learned, num in learnings.allLearned()
        response += "##{learned.num} - #{learned.learn}\n"
      msg.send response
    else
      msg.send "Doh! I guess I'm still pretty stupid..."

  robot.respond /(you learned|learned|you learned to|learned to) #?(\d+)/i, (msg) ->
    learnNum = msg.match[2]
    # remove from the "things to learn" list
    learn = learnings.deleteByNumber learnNum
    
    msg.send "Thank you Master, I'm happy to please you. I'll mark as learned : ##{learn.num} - #{learn.learn}"
    
    # add to the learned list
    learned = learnings.addLearned learn.learn

  robot.respond /(forget to learn|forget about) #?(\d+)/i, (msg) ->
    learnNum = msg.match[2]
    learn = learnings.deleteByNumber learnNum
    msg.send "Perfecto, I didn't plan to learn this anyway. I deleted from my list: ##{learn.num} - #{learn.learn}"
