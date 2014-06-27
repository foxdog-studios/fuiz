Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'


Router.onBeforeAction 'loading'


Router.map ->
  @route 'master',
    path: RouterUtils.makePath 'master'
    controller: 'MasterRouteController'

