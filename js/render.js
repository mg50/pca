function renderHomography(sourcePoints, targetPoints, image, canvas) {
  var s1 = sourcePoints[0], s2 = sourcePoints[1], s3 = sourcePoints[2], s4 = sourcePoints[3];
  var t1 = targetPoints[0], t2 = targetPoints[1], t3 = targetPoints[2], t4 = targetPoints[3];
  var mat = getInverseHomographyMatrix(
    s1[0], s1[1], s2[0], s2[1], s3[0], s3[1], s4[0], s4[1],
    t1[0], t1[1], t2[0], t2[1], t3[0], t3[1], t4[0], t4[1]
  );

  var ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.drawImage(image, 0, 0);
  var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  var h = imgData.height, w = imgData.width, data = imgData.data;

  var newImgData = ctx.createImageData(w, h);
  var newData = newImgData.data;
  for(var i = 0, len = data.length; i < len; i += 4) {
    var j = i/4;
    var x = j % w;
    var y = Math.floor((j - x) / w);

    var result = numeric.dot(mat, [x, y, 1]);
    var preX = Math.round(result[0]/result[2]);
    var preY = Math.round(result[1]/result[2]);

    if(preX >= 0 && preX < w && preY >= 0 && preY < h) {
      var preI = (preY*w + preX)*4;
      newData[i+0] = data[preI+0];
      newData[i+1] = data[preI+1];
      newData[i+2] = data[preI+2];
      newData[i+3] = data[preI+3];
    }
  }

  ctx.putImageData(newImgData, 0, 0);
}

function getInverseHomographyMatrix(sx1, sy1, sx2, sy2, sx3, sy3, sx4, sy4,
                                    tx1, ty1, tx2, ty2, tx3, ty3, tx4, ty4) {
  var matrix = makeRows(sx1, sy1, tx1, ty1)
    .concat(makeRows(sx2, sy2, tx2, ty2))
    .concat(makeRows(sx3, sy3, tx3, ty3))
    .concat(makeRows(sx4, sy4, tx4, ty4));

  var target = [tx1, ty1, tx2, ty2, tx3, ty3, tx4, ty4];
  var result = numeric.dot(numeric.inv(matrix), target);

  return numeric.inv([[result[0], result[1], result[2]],
                      [result[3], result[4], result[5]],
                      [result[6], result[7], 1]]);
}

function makeRows(sx, sy, tx, ty) {
  var r1 = [sx, sy, 1, 0, 0, 0, -1*sx*tx, -1*sy*tx];
  var r2 = [0, 0, 0, sx, sy, 1, -1*sx*ty, -1*sy*ty];
  return [r1, r2];
}
