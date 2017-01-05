Signature = undefined
baseUrl = '<%=basePath%>WxBus/'
$ ->
  url = parseURL location.href
  # url = parseURL 'http://weixin.7ipr.com/Repository/upload/weixin/wxtask/2016121540289de657f5d7990157f5d981600000.html?userId=ot5hAwk0kFP5vdbo1QVYVr_YeMjE&taskId=40289de657f5d7990157f5d981600000&taskBusId=0a7b1135-8887-4d03-b03a-ec4b8dfbbcd4'
  queryString = parseParam url.params, null
  link = location.href
  if queryString.indexOf('type') > -1
    link = link.replace("&type=1","")
  else
    doPost 'click',queryString
  $.ajax
    type: 'POST'
    url: '<%=basePath%>WxPlatform/getSignature'
    data: url: location.href
    async: false
    dataType: 'json'
    success: (rs) ->
      Signature = rs.data
      return
  wx.config
    debug: false
    appId: Signature['appId']
    timestamp: Signature['timestamp']
    nonceStr: Signature['noncestr']
    signature: Signature['signature']
    jsApiList: [
      'onMenuShareTimeline'
      'onMenuShareAppMessage'
      'onMenuShareQQ'
      'onMenuShareWeibo'
      'onMenuShareQZone'
    ]
  #title = '' //分享标题
  #desc = '' //分享链接
  #link = '' //分享链接
  #imgUrl = '' //分享图标
  #type = '' //分享类型,music、video或link，不填默认为link
  # dataUrl = '' //如果type是music或video，则要提供数据链接，默认为空
  wx.ready ->
    configs =
      title: '<%=title%>'
      link: link
      imgUrl: '<%=imgUrl%>'
      desc: '<%=desc%>'
      success: ->
        console.log 'share'
        doPost 'share',queryString
        return
      cancel: ->
        console.log 'cacnel share'
        return
    wx.onMenuShareTimeline configs
    wx.onMenuShareAppMessage configs
    wx.onMenuShareQQ configs
    wx.onMenuShareWeibo configs
    wx.onMenuShareQZone configs
    return
  return


doPost = (action,queryString) ->
  settings =
    'url': "#{baseUrl}#{action}/?#{queryString}"
    'method': 'POST'

  $.ajax(settings).done((response) ->
    # console.log 'response=>' + response
    return
  ).fail (error) ->
    console.error error
    return
  return

###*
# js解析url方法
###
parseURL = (url) ->
  a = document.createElement('a')
  a.href = url
  {
    source: url
    protocol: a.protocol.replace(':', '')
    host: a.hostname
    port: a.port
    query: a.search
    params: do ->
      ret = {}
      seg = a.search.replace(/^\?/, '').split('&')
      len = seg.length
      i = 0
      s = undefined
      while i < len
        if ! seg[i]
          i++
          continue
        s = seg[i].split('=')
        ret[s[0]] = s[1]
        i++
      ret
    file: (a.pathname.match(/\/([^\/?#]+)$/i) or [ '' ])[1]
    hash: a.hash.replace('#', '')
    path: a.pathname.replace(/^([^\/])/, '/$1')
    relative: (a.href.match(/tps?:\/\/[^\/]+(.+)/) or [ '' ])[1]
    segments: a.pathname.replace(/^\//, '').split('/')
  }

###*
# param 将要转为URL参数字符串的对象
###

parseParam = (param, key) ->
  paramStr = ''
  if param instanceof String or param instanceof Number or param instanceof Boolean
    paramStr += "&#{key}=#{encodeURIComponent(param)}"
  else
    $.each param, (i) ->
      k = if key == null then i else key + (if param instanceof Array then '[' + i + ']' else '.' + i)
      paramStr += "&#{parseParam(this, k)}"
      return
  paramStr.substr 1
