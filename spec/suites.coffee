m = require('mixation')

describe 'mixin system', ->
  require('./mixation/mixin.coffee')(m.mixin, m.mixable)

describe 'mixable modules', ->
  require('./mixation/mixable.spec.coffee')(m.mixin, m.mixable)
