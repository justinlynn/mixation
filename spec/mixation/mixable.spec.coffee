module.exports = (m, mixable) ->

  it 'defines an included function', ->
    mixable.should.have.property 'included'
    mixable.included.should.be.type 'function'

  describe 'included function', ->

    class TestMixin extends mixable
      @includedTag = false

      @included: (args...) ->
        @includedTag = true

    class Target

    it 'called back by the Mixin module on includeInto action', ->

      TestMixin.includedTag.should.be.false
      m.includeInto Target, TestMixin
      TestMixin.includedTag.should.be.true

  it 'defines an extended function', ->
    mixable.should.have.property 'extended'
    mixable.extended.should.be.type 'function'

  describe 'extended function', ->

    class TestMixin extends mixable
      @extendedTag = false

      @extended: (args...) ->
        @extendedTag = true

    class Target

    it 'called back by the Mixin module on extendInto action', ->

      TestMixin.extendedTag.should.be.false
      m.extendInto Target, TestMixin
      TestMixin.extendedTag.should.be.true