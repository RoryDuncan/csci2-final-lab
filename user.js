// Generated by CoffeeScript 1.8.0
var Joi, User, id, scheme;

Joi = require('Joi');

scheme = {
  username: Joi.string().max(64).required(),
  password: Joi.string().max(255).required()
};

id = 0;

User = function(username, password) {
  this.isValid = Joi.validate({
    username: username,
    password: password
  }, scheme).error === null;
  this.username = username;
  this.password = password;
  this.id = ++id;
  return this;
};

User.prototype.save = function() {
  throw new Error("Not Implemented");
};

User.prototype.isValid = false;

module.exports = User;
