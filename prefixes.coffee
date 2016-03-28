JiraClient = require 'jira-connector'

jira = new JiraClient({
  host: 'sadasystems.atlassian.net',
  basic_auth: {
    username: '',
    password: ''
  }
})

linkifier =
  "url": jira.host
  "prefixes": ""

prefixes = []

jira.project.getAllProjects({}, (err, res, body) ->

  body.body.forEach((key) ->
    prefixes.push(key.key)
  )

  linkifier.prefixes = prefixes.join ','

  console.log JSON.stringify linkifier

)