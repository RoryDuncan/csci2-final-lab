Hapi = require 'hapi'
Basic = require 'hapi-auth-basic'
Joi = require 'Joi'
Auth = require './auth.js'
User = require './user.js'

server = new Hapi.Server()
server.connection({port: process.env.PORT or 5000})

###
SETUP DB
###

client = require('redis').createClient( process.env.REDIS_URL );

users = {}

auth = new Auth(users)


###
  REGISTER VIEWS
###

server.views
  engines:
    jade: require('jade')
  relativeTo: __dirname
  path: './views'
  layoutPath: './views/shared'
  isCached: false

###
ROUTES
###




# static assets

server.route
    method: 'GET'
    path:'/favicon.ico'
    handler: (request, reply) ->
      reply.file("./favicon.ico");

server.route
    method: 'GET'
    path: '/images/{file*}'
    handler:
      directory:
        path: 'public/images',
        listing: true

server.route
    method: 'GET'
    path: '/css/{file*}'
    handler:
      directory:
        path: 'public/css'
        listing: true

server.route
  method: 'GET'
  path: '/scripts/{file*}'
  handler:
    directory:
      path: 'public/scripts'
      listing: true

server.route
    method: 'GET'
    path: '/{file*}'
    handler:
      directory:
        path: 'public'
        listing: true


# authentication

server.register require('hapi-auth-cookie'), (err) ->
  console.log err if err

  cookieOptions =
    password: 'dingodango'
    cookie: 'sid-example'
    isSecure: false

# strategies
  server.auth.strategy('session', 'cookie', cookieOptions)

# SIGNUP
  server.route
    method: 'POST'
    path:'/signup'
    handler: (req, reply) ->
      user = new User req.payload.username, req.payload.password
      if user.isValid
        users[user.username] = user
        req.auth.session.set(user)
        reply.redirect("/")
      else
        reply.view("index", {errors: "Invalid username or password."})

# SIGNUP
  server.route
    method: 'GET'
    path:'/signup'
    handler: (req, reply) ->
      reply.redirect("/")

# USERS
  server.route
    method: 'GET'
    path:'/users'
    handler: (req, reply) ->
      reply(users)



# LOGIN
  server.route
    method: 'POST'
    path:'/login'
    config:
      auth:
        strategy: "session"
        mode: 'try'
      handler: (req, reply) ->
        reply.view('index')

# LOGOUT
  server.route
    method: 'GET'
    path:'/logout'
    config:
      auth:
        strategy: "session"
        mode: 'try'
    handler: (req, reply) ->
      console.log req.auth
      if req.auth.isAuthenticated
        req.auth.session.clear()
        reply.view("logout")
      else
        reply.redirect "/"

# HOME
  server.route
    method: 'GET'
    path:'/'
    config:
      auth:
        strategy: "session"
        mode: 'try'
      handler: (req, reply) ->
        if req.auth.isAuthenticated
          reply.view("index", {user: req.auth.credentials})
        else
          reply.view('index')

# default
  server.route
    method: '*',
    path: '/{anything*}', # catch-all path
    handler: (request, reply) ->
      reply.redirect("/")

  server.start () ->
    console.log "Server running on #{server.info.uri}"
