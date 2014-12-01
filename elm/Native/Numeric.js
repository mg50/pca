var numeric = numeric || null;
if(numeric === null) throw('numeric.js not found')

Elm.Native.Numeric = {};
Elm.Native.Numeric.make = function(elm) {
  var A = Elm.Native.Array.make(elm);
  var L = Elm.Native.List.make(elm);
  var Utils = Elm.Native.Utils.make(elm);
  var JS = Elm.Native.JavaScript.make(elm);

  function map(ary, f) {
    for(var i = 0, len = ary.length; i < len; i++)
      ary[i] = f(ary[i]);

    return ary;
  }

  elm.Native = elm.Native || {};
  elm.Native.Numeric = elm.Native.Numeric || {};
  if (elm.Native.Numeric.values) return elm.Native.Numeric.values;

  function matrixToJSArray(m) {
    m = A.toJSArray(m);
    for(var i = 0, len = m.length; i < len; i++)
      m[i] = A.toJSArray(m[i]);

    return m;
  }

  function jsArrayToMatrix(m) {
    var len = m.length, result = new Array(len);
    for(var i = 0; i < len; i++)
      result[i] = A.fromJSArray(m[i])

    return A.fromJSArray(result);
  }

  function mmDot(m1, m2) {
    m1 = matrixToJSArray(m1);
    m2 = matrixToJSArray(m2);

    var result = numeric.dot(m1, m2);
    return jsArrayToMatrix(result);
  }

  function transpose(m) {
    m = matrixToJSArray(m);
    var t = numeric.transpose(m);
    return jsArrayToMatrix(t);
  }

  function makeImVect(len, im) {
    if(im === undefined) {
      im = new Array(len);
      for(var i = 0; i < len; i++) im[i] = 0;
    }

    return A.fromJSArray(im);
  }

  function makeImMatrix(len, im) {
    if(im === undefined) {
      im = new Array(len);
      for(var i = 0; i < len; i++) im[i] = 0;
    }

    return A.fromArray(im);
  }

  function eig(m) {
    m = matrixToJSArray(m);
    var result = numeric.eig(m);

    var lambda = result.lambda;
    var eigenvalues = JS.toRecord({real: [], imaginary: []});
    eigenvalues.real = L.fromArray(lambda.x);
    eigenvalues.imaginary = makeImVect(lambda.x.length, lambda.y);

    var E = result.E;
    var eigenvectors = JS.toRecord({real: [], imaginary: []});
    // it turns out that numeric.js returns the eigenvectors as columns, so we transpose
    eigenvectors.real = L.fromArray(map(numeric.transpose(E.x), A.fromJSArray));
    if(E.y) {

    }
    //TODO: Fix this
    eigenvectors.imaginary = L.fromArray([]);

    var out = JS.toRecord({
      eigenvalues: [],
      eigenvectors: []
    });

    out.eigenvectors = eigenvectors;
    out.eigenvalues = eigenvalues;

    return out;
  }

  return Elm.Native.Numeric.values = {
    eig: eig,
    transpose: transpose,
    mmDot: F2(mmDot),
  };
};
