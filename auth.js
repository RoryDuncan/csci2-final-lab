// Generated by CoffeeScript 1.8.0
var Auth, users;

users = null;

Auth = function(us) {
  users = us;
  return this;
};

Auth.prototype.logout = function(req, reply) {};

Auth.prototype.signup = function(request, username, password, callback) {
  var credentials, errors, userExists;
  errors = [];
  if (!username) {
    errors.push("username is required");
  }
  if (!password) {
    errors.push("username is password");
  }
  if (errors.length > 0) {
    return callback(errors, false, {
      username: username,
      password: password
    });
  }
  userExists = users[username];
  if (!userExists) {
    credentials = {
      username: username,
      password: password
    };
    console.log("Signing up as " + username);
    users[username] = credentials;
    return callback(null, true, credentials);
  }
  errors.push("Username is taken");
  if (password.length <= 1) {
    errors.push("Password is too short.");
  }
  console.log("There were errors:", errors);
  return callback(errors, false, {
    username: username,
    password: password
  });
};

Auth.prototype.validate = function(request, username, password, callback) {
  var isValid, user;
  console.log("Checking for user", username);
  user = users[username];
  if (!user) {
    return callback(null, false);
  }
  isValid = password === user.password;
  if (isValid) {
    return callback(null, isValid, {
      username: username,
      name: user.name
    });
  }
  return callback(null, false);
};

module.exports = Auth;
