
users = null


Auth = (us) ->

  users = us

  return @

Auth::logout = (req, reply) ->

  return

Auth::signup = (request, username, password, callback) ->

  # username = request.payload.username
  # password = request.payload.password
  errors = []

  errors.push "username is required" unless username
  errors.push "username is password" unless password

  return callback(errors, false, {username, password}) if errors.length > 0

  userExists = users[username]

  unless userExists
    credentials = {username, password}
    console.log "Signing up as #{username}"
    users[username] = credentials
    return callback(null, true, credentials)

  errors.push "Username is taken"

  if password.length <= 1
    errors.push "Password is too short."

  console.log "There were errors:", errors

  return callback(errors, false, {username, password})




Auth::validate = (request, username, password, callback) ->
  console.log "Checking for user", username
  user = users[username]
  return callback(null, false) unless user

  isValid = password is user.password

  if isValid
    return callback(null, isValid, {username, name: user.name})

  return callback(null, false)



module.exports = Auth
