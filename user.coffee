Joi = require 'Joi'
scheme =
  username: Joi.string().max(64).required()
  password: Joi.string().max(255).required()

id = 0

User = (username, password) ->
  @isValid = Joi.validate({username, password}, scheme).error is null
  @username = username
  @password = password
  @id = ++id
  return @

User::save = () ->
  throw new Error("Not Implemented")

User::isValid = false


module.exports = User
