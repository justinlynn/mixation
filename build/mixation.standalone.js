!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.mixation=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
module.exports = {
  mixin: _dereq_('./mixation/mixin.coffee'),
  mixable: _dereq_('./mixation/mixable.coffee')
};



},{"./mixation/mixable.coffee":2,"./mixation/mixin.coffee":3}],2:[function(_dereq_,module,exports){
var Mixable,
  __slice = [].slice;

Mixable = (function() {
  function Mixable() {}

  Mixable.classMethods = {};

  Mixable.instanceMethods = {};

  Mixable.included = function() {
    var args, module, target;
    target = arguments[0], module = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  };

  Mixable.extended = function() {
    var args, module, target;
    target = arguments[0], module = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
  };

  return Mixable;

})();

module.exports = Mixable;



},{}],3:[function(_dereq_,module,exports){
var Mixin,
  __slice = [].slice;

Mixin = (function() {
  function Mixin() {}

  Mixin._checkMixableCompatibilityAcrossAllModules = function(target, mixables) {
    var extractMethodCollectionFromMixables, filterIncompatibleMethods, incompatibleMethods, insertTargetIntoMethodCollection, methodCollection;
    extractMethodCollectionFromMixables = function(mixables, modules) {
      var method, methodCollection, mixable, module, _base, _i, _j, _k, _len, _len1, _len2, _ref;
      methodCollection = {};
      for (_i = 0, _len = mixables.length; _i < _len; _i++) {
        mixable = mixables[_i];
        for (_j = 0, _len1 = modules.length; _j < _len1; _j++) {
          module = modules[_j];
          methodCollection[module] || (methodCollection[module] = {});
          _ref = Object.getOwnPropertyNames(mixable[module]);
          for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
            method = _ref[_k];
            (_base = methodCollection[module])[method] || (_base[method] = []);
            methodCollection[module][method].push(mixable);
          }
        }
      }
      return methodCollection;
    };
    methodCollection = extractMethodCollectionFromMixables(mixables, ['classMethods', 'instanceMethods']);
    insertTargetIntoMethodCollection = function(target, methodCollection) {
      var classMethods, instanceMethods, method, _i, _j, _len, _len1, _results;
      classMethods = [];
      instanceMethods = [];
      classMethods = Object.getOwnPropertyNames(target);
      instanceMethods = Object.getOwnPropertyNames(target.constructor);
      for (_i = 0, _len = classMethods.length; _i < _len; _i++) {
        method = classMethods[_i];
        if (!(Object.prototype.toString.call(methodCollection['classMethods'][method]) === '[object Array]')) {
          methodCollection['classMethods'][method] = [];
        }
        methodCollection['classMethods'][method].push(target);
      }
      _results = [];
      for (_j = 0, _len1 = instanceMethods.length; _j < _len1; _j++) {
        method = instanceMethods[_j];
        if (!(Object.prototype.toString.call(methodCollection['instanceMethods'][method]) === '[object Array]')) {
          methodCollection['instanceMethods'][method] = [];
        }
        _results.push(methodCollection['instanceMethods'][method].push(target));
      }
      return _results;
    };
    insertTargetIntoMethodCollection(target, methodCollection);
    filterIncompatibleMethods = function(methodCollection) {
      var incompatibleMethods, method, module, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      incompatibleMethods = {};
      _ref = Object.keys(methodCollection);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        module = _ref[_i];
        incompatibleMethods[module] || (incompatibleMethods[module] = {});
        _ref1 = Object.keys(methodCollection[module]);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          method = _ref1[_j];
          if (methodCollection[module][method].length > 1) {
            incompatibleMethods[module][method] = methodCollection[module][method];
          }
        }
      }
      _ref2 = Object.keys(incompatibleMethods);
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        module = _ref2[_k];
        if (Object.keys(incompatibleMethods[module]).length === 0) {
          delete incompatibleMethods[module];
        }
      }
      return incompatibleMethods;
    };
    incompatibleMethods = filterIncompatibleMethods(methodCollection);
    if (Object.keys(incompatibleMethods).length !== 0) {
      throw {
        name: 'incompatibleMixAttemptedError',
        msg: 'An attempt was made to mixin incompatible mixables. See underlyingReason for debugging information',
        underlyingReason: incompatibleMethods
      };
    } else {
      return void 0;
    }
  };

  Mixin._mixInto = function(target, destination, module, context, mixables) {
    var mixable, property, _i, _j, _len, _len1, _ref;
    for (_i = 0, _len = mixables.length; _i < _len; _i++) {
      mixable = mixables[_i];
      _ref = Object.keys(mixable[module]);
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        property = _ref[_j];
        destination.prototype[property] = mixable[module][property];
      }
      mixable[context](target, destination, module);
    }
    return void 0;
  };

  Mixin._extendInto = function(target, mixables) {
    return this._mixInto(target, target.constructor, 'classMethods', 'extended', mixables);
  };

  Mixin._includeInto = function(target, mixables) {
    return this._mixInto(target, target, 'instanceMethods', 'included', mixables);
  };

  Mixin.extendInto = function() {
    var mixables, target;
    target = arguments[0], mixables = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    this._checkMixableCompatibilityAcrossAllModules(target, mixables);
    return this._extendInto(target, mixables);
  };

  Mixin.includeInto = function() {
    var mixables, target;
    target = arguments[0], mixables = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    this._checkMixableCompatibilityAcrossAllModules(target, mixables);
    return this._includeInto(target, mixables);
  };

  Mixin.composeInto = function() {
    var mixables, target;
    target = arguments[0], mixables = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    this._checkMixableCompatibilityAcrossAllModules(target, mixables);
    this._extendInto(target, mixables);
    return this._includeInto(target, mixables);
  };

  return Mixin;

})();

module.exports = Mixin;



},{}]},{},[1])
(1)
});