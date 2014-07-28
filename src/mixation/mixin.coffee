class Mixin

  @_checkMixableCompatibilityAcrossAllModules: (target, mixables) ->

    extractMethodCollectionFromMixables = (mixables, modules) ->
      methodCollection = {}
      for mixable in mixables
        for module in modules
          methodCollection[module] ||= {}
          for method in Object.getOwnPropertyNames(mixable[module])
            methodCollection[module][method] ||= []
            methodCollection[module][method].push mixable
      return methodCollection

    methodCollection = extractMethodCollectionFromMixables mixables, ['classMethods','instanceMethods']

    # treat target as destination
    insertTargetIntoMethodCollection = (target, methodCollection) ->

      classMethods = []
      instanceMethods = []

      classMethods = Object.getOwnPropertyNames target
      instanceMethods = Object.getOwnPropertyNames target.constructor

      for method in classMethods
        if !(Object.prototype.toString.call( methodCollection['classMethods'][method] ) == '[object Array]')
          methodCollection['classMethods'][method] = []
        methodCollection['classMethods'][method].push target

      for method in instanceMethods
        if !(Object.prototype.toString.call( methodCollection['instanceMethods'][method] ) == '[object Array]')
          methodCollection['instanceMethods'][method] = []
        methodCollection['instanceMethods'][method].push target

    insertTargetIntoMethodCollection(target, methodCollection)

    filterIncompatibleMethods = (methodCollection) ->
      incompatibleMethods = {}
      for module in Object.keys(methodCollection)
        incompatibleMethods[module] ||= {}
        for method in Object.keys(methodCollection[module])
          if methodCollection[module][method].length > 1
            incompatibleMethods[module][method] = methodCollection[module][method]
      for module in Object.keys(incompatibleMethods)
        delete incompatibleMethods[module] if Object.keys(incompatibleMethods[module]).length == 0
      return incompatibleMethods

    incompatibleMethods = filterIncompatibleMethods(methodCollection)

    if (Object.keys(incompatibleMethods).length != 0)
      throw {
        name: 'incompatibleMixAttemptedError'
        msg: 'An attempt was made to mixin incompatible mixables. See underlyingReason for debugging information'
        underlyingReason: incompatibleMethods
      }
    else
      return undefined

  @_mixInto: (target, destination, module, context, mixables) ->
    for mixable in mixables
      for property in Object.keys mixable[module]
        destination::[property] = mixable[module][property]
      mixable[context](target, destination, module)
    return undefined

  @_extendInto: (target, mixables) ->
    @_mixInto(target, target.constructor, 'classMethods', 'extended', mixables)

  @_includeInto: (target, mixables) ->
    @_mixInto(target, target, 'instanceMethods', 'included', mixables)

  @extendInto: (target, mixables...) ->
    @_checkMixableCompatibilityAcrossAllModules target, mixables
    @_extendInto(target, mixables)

  @includeInto: (target, mixables...) ->
    @_checkMixableCompatibilityAcrossAllModules target, mixables
    @_includeInto(target, mixables)

  @composeInto: (target, mixables...) ->
    @_checkMixableCompatibilityAcrossAllModules target, mixables
    @_extendInto target, mixables
    @_includeInto target, mixables

##
module.exports = Mixin