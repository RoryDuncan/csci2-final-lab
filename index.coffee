Hapi = require 'hapi'
server = new Hapi.Server()
server.connection({port: process.env.PORT or 5000})


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


# defaults

server.route
  method: 'GET'
  path:'/'
  handler: {view: 'index'}


server.route
  method: '*',
  path: '/{anything*}', # catch-all path
  handler: (request, reply) ->
    reply.redirect("/")

server.start () ->
  console.log "Server running on #{server.info.uri}"
