$('body').on 'submit', (event) ->
  event.preventDefault();
  $.ajax
    url: '/drinks/:name'
    type: 'GET'
    dataType: 'json'
    data: $(this).serialize
    success: ->
      console.log data
    error: ->
      alert 'Error'
  .done (data) ->
    console.log data

window.renderGlass = (options) ->
  s = Snap($(window).width(), 800)
  p = 100 / 30
  h = 250
  x = 400
  y = 200
  R = 100
  r = 70
  open = 0
  gfirst = 'l()#color of first ingedient-#function to light color:50-#color of first ingedient:50-#color of first ingedient'
            "#F4EEE6-#fff:50-#F4EEE6:50-#F4EEE6",
            rgb(244, 238, 230) rgb(255, 255, 255)
  gsecond = 'l()#60544F-#8c7a73:50-#60544F:50-#60544F'
                rgb(96, 84, 79)  rgb(140, 122, 115)
  gthird = 'l()#B4D6DB-#D6EDEE:50-#B4D6DB:50-#B4D6DB'
                rgb(180, 214, 219) rgb(214, 237, 238)
  Snap.load 'demo.svg', (f) ->
    top = f.select '#top'
    bot = f.select '#bottom'
    tap = f.select '#tap'
    angle = 0
    grp = s.g().insertBefore tap
    x = $(window).width() / 2
    y = 75
    R = 120
    r = 92
    h = 280
    s.add f.select('g')
    grp.path(outline(0, h)).attr 'class', 'outline'
    o5 = (h - 70) / 5
    o4 = (h - 70) / 4
    o3 = (h - 70) / 3
    # o2 = (h - 70) / 2
    cover = grp.ellipse(getEll(h - 60))
    ct1 = grp.path(cut(10, 10 + o3, 0)).attr
      fill: INSERT COLOR OF FIRST INGREDIENT
    ct2 = grp.path(cut(10 + o3, h - 60, 0)).attr
      fill: INSERT COLOR OF SECOND INGREDIENT
    middle = 10 + o3
    g = grp.g()
    dr = grp.path(doors(0)).attr 'class', 'doors'
    
    totalOunces = _.reduce([array of ozs], ()->{} ,0)


    types =
      0: -> #for 2 ingredients
        cover.attr fill : 'rgb(25,25,25)'
        ct2.attr 'fill', gwater
        middle = 10 + o4 * 2
      72: ->
        cover.attr 'class', 'milk'
        ct2.attr 'fill', gmilk
        middle = 10 + o3
      144: ->
        cover.attr 'class', 'milk'
        ct2.attr 'fill', gmilk
        middle = 10 + o4
      216: ->
        cover.attr 'class', 'milk'
        ct2.attr 'fill', gmilk
        middle = 10 + o5

    closeCup = (callback) ->
      Snap.animate 90, 0, (val) ->
        ct1.attr 'path', cut(10, middle, val)
        ct2.attr 'path', cut(middle, h - 60, val)
        dr.attr 'path', doors(val)
      , 500, mina.easein, callback

    pour = ->
      Snap.animate 0, 90, (val) ->
        ct1.attr 'path', cut(10, middle, val)
        ct2.attr 'path', cut(middle, h - 60, val)
        dr.attr 'path', doors(val)
      , 1500, mina.elastic

    types[
      if(totIngdts === 1){
        return 0
      }else if(totIngdts === 2){
        return 72
      }else if(totIngdts === 3){
        return 144
      }
    ]()
    pour() if options.slice is true

  getEll = (height) ->
    ra = r + (R - r) / h * height
    cx: x
    cy: y + h - height
    rx: ra
    ry: ra / p

  arc = (cx, cy, R, r, from, to, command) ->
    start = pointAtAngle(cx, cy, R, r, from)
    end = pointAtAngle(cx, cy, R, r, to)
    command = command || 'M'
    command + Snap.format "{sx},{sy}A{R},{r},0,{big},{way},{tx},{ty}",
      sx: start.x
      sy: start.y
      R: R
      r: r
      tx: end.x
      ty: end.y
      big: +(Math.abs(to - from) > 180)
      way: +(from > to)

  pointAtAngle = (cx, cy, rx, ry, angle) ->
    angle = Snap.rad angle
    x: cx + rx * Math.cos(angle)
    y: cy - ry * Math.sin(angle)

  doors = (alpha) ->
    sa = 270 - alpha / 2
    ea = 270 + alpha / 2
    if alpha
      arc(x, y, R, R / p, 180, sa) +
      arc(x, y + h, r, r / p, sa, 180, 'L') +
      'z' +
      arc(x, y, R, R / p, ea, 360) +
      arc(x, y + h, r, r / p, 360, ea, 'L') + 'z'
    else
      arc(x, y, R, R / p, 180, 360) +
      arc(x, y + h, r, r / p, 360, 180, 'L') + 'z'

  fill = (from, to) ->
    start = getEll from
    end = getEll to
    'M' + (start.cx - start.rx) + ',' + start.cy + 'h' + start.rx * 2 +
      arc(end.cx, end.cy, end.rx, end.ry, 0, 180, 'L') + 'z'

  outline = (from, to) ->
    start = getEll from
    end = getEll to
    arc(start.cx, start.cy, start.rx, start.ry, 180, 0) +
      arc(end.cx, end.cy, end.rx, end.ry, 0, 180, 'L') + 'z'

  cut = (from, to, alpha) ->
    s = getEll from
    e = getEll to
    sa = Snap.rad 270 - alpha / 2
    ea = Snap.rad 270 + alpha / 2
    'M' + [
      s.cx
      s.cy
      s.cx + s.rx * Math.cos(ea)
      s.cy - s.ry * Math.sin(ea)
      e.cx + e.rx * Math.cos(ea)
      e.cy - e.ry * Math.sin(ea)
      e.cx
      e.cy
      e.cx + e.rx * Math.cos(sa)
      e.cy - e.ry * Math.sin(sa)
      s.cx + s.rx * Math.cos(sa)
      s.cy - s.ry * Math.sin(sa)
    ] + 'z'

  hexToArray = (hexCode) ->
    hexArray = []
    for i in [0...2] by step
      hexArray.push(hexCode.slice(i,i+2))
    return hexArray

  hexIncrease = (value) ->
    v = value
    if v > 240
      return v * 1.045
    else if v > 200
      return v * 1.09
    else if v > 150
      return v * 1.18
    else if v > 100
      return v *1.20
    else
      return v * 1.45
    
    return

  lightenHex = (hexCode) ->
    hexArray = hexToArray(hexCode)
    newHex = []
    for i in [0...2] by step
      oldNum = parseInt '0x'+newHex[i], 16
      newNum = hexIncrease(oldNum)
      newHex.push newNum.toString 16
    return newHex.join ''
