# Description
#   Hubot listens for a list of your Jira project codes and responds with full
#   clickable links to the tickets that are generated from the configured Jira
#   base url.
#
# Configuration:
#  HUBOT_JIRA_LINKIFIER_JIRA_URL
#  HUBOT_JIRA_LINKIFIER_PROJECT_PREFIXES
#
# Commands:
#   hubot jl url      - Responds with the configured Jira base URL
#
#   hubot jl prefixes - Responds with the configured Jira project prefixes to
#                       build URLs for e.g. "DEV" for DEV-111
#
#   hubot jl regex    - Responds with the configured Jira base URL,
#                       currently just for debugging
#
#
# Author:
#   Chris Coveney <xkickflip@gmail.com>

module.exports = (robot) ->

  try
    config = require '../../../jira-linkifier'
  catch e
    console.error 'no jira-linkifier.json config provided, trying env variables'

  # ENV variable for list of project prefixes
  prefixes = process.env.HUBOT_JIRA_LINKIFIER_PROJECT_PREFIXES?.split(',') || config?.prefixes.split(',') || []

  # Base URL for your JIRA install.  Strip trailing slash if it's included
  jiraUrl = process.env.HUBOT_JIRA_LINKIFIER_JIRA_URL || config?.url || ''

  # Strip leading & trailing whitespace & trailing /
  jiraUrl = jiraUrl.replace /^\s+|\s+$|\/\s*$/g, ""


  prefixList = prefixes.join('|')
  ticketRegExp = new RegExp "(^|\\s+)(#{prefixList})-[0-9]+($|\\s+)", "gi"

  robot.hear ticketRegExp, (res) ->
    for ticketMatch in res.match
      res.send "#{jiraUrl}/browse/#{ticketMatch.trim().toUpperCase()}"


  # TODO: debug print the generated regex, remove me
  robot.respond /jl regexp/i, (res) ->
    res.send ticketRegExp


  # "jl url": respond with the configured Jira base url
  robot.respond /jl url/i, (res) ->
    res.send jiraUrl


  # "jl prefixes": respond with all current Jira prefixes that will be matched
  robot.respond /jl prefixes/i, (res) ->
    if prefixes.length == 0
      res.send "Jira Prefix list is empty."
    else
      res.send "Currently matching Jira project prefixes: #{prefixes.join(', ')}"