should = require('should')

module.exports = (Mixin, Mixable) ->

  describe 'on classes with namespace conflicts', ->
    describe 'in class methods', ->
      class MixableA extends Mixable
        @classMethods:
          conflictingMethod: ->

      class Target
        @conflictingMethod: ->

      it 'should raise an appropriate error about potential method overwrite', ->
        should(->
          Mixin.extendInto Target, MixableA
        ).throw()

  describe 'on multiple mixin operation with namespace conflicts', ->
    describe 'in class methods on mixables', ->
      class MixableA extends Mixable
        @classMethods:
          conflictingMethod: ->
      class MixableB extends Mixable
        @classMethods:
          conflictingMethod: ->
      class Target

      it 'should raise an appropriate error about the potential method overwrite and mixin nothing', ->
        should(->
          Mixin.extendInto Target, MixableA, MixableB
        ).throw()

    describe 'in instance methods on mixables', ->
      class MixableA extends Mixable
        @instanceMethods:
          testMethod: ->
          conflictingMethod: ->
      class MixableB extends Mixable
        @instanceMethods:
          conflictingMethod: ->
      class Target

      it 'should raise an appropriate error about the potential method overwrite and mixin nothing', ->
        should(->
          Mixin.includeInto Target, MixableA, MixableB
        ).throw()
        Target.should.not.have.property 'testMethod'

  describe 'on classes with the extendInto method', ->
    class TestMixable extends Mixable
      @classMethods:
        testFunction: ->

    class Target
      Mixin.extendInto @, TestMixable

    it 'inserts the properties defined on the mixable module into the target prototype', ->
      Target.should.have.property 'testFunction'
      Target.testFunction.should.be.type 'function'

  describe 'on classes with the includeInto method', ->
    class TestMixable extends Mixable
      @instanceMethods:
        testInstanceFunction: ->

    class Target
      Mixin.includeInto @, TestMixable

    it 'inserts the properties defined on the mixable module into the target instance', ->
      targetInstance = new Target
      targetInstance.should.have.property 'testInstanceFunction'
      targetInstance.testInstanceFunction.should.be.type 'function'

  describe 'on classes with the composeInto method', ->
    class TestMixable extends Mixable
      @instanceMethods:
        testInstanceFunction: ->
          3
      @classMethods:
        testClassFunction: ->
          5

    class Target
      Mixin.composeInto @, TestMixable

    it 'inserts the properties defined on the mixable classMethods module into the target', ->
      Target.should.have.property 'testClassFunction'
      Target.testClassFunction.should.be.type 'function'
      Target.testClassFunction().should.equal 5

    it 'inserts the properties defined on the mixable instanceMethods module into the target prototype', ->
      targetInstance = new Target
      targetInstance.should.have.property 'testInstanceFunction'
      targetInstance.testInstanceFunction.should.be.type 'function'
      targetInstance.testInstanceFunction().should.equal 3