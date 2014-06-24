Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'


Router.onBeforeAction 'loading'


Router.map ->
  @route 'master',
    path: RouterUtils.makePath 'master'
    controller: 'MasterRouteController'

