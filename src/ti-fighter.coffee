# ## TiFighter
#
# TiFighter is a jQuery-like library designed to help you wage intergalactic
# war on your Titanium Mobile applications.
#
# @author      Joshua Priddle <jpriddle@nevercraft.net>
# @url         https://github.com/itspriddle/ti-fighter
# @version     0.0.0

window = this

class TiFighter
  # Initialize a new TiFighter object
  constructor: (el, context) ->
    return new TiFighter.init el, context

  # Initialize a new TiFighter object
  # Tries to find el within context
  @init: (el, context) ->
    if ! el
      return this
    else
      if typeof el == 'string'
        target = context[el]
        @name  = target
      else
        target = el

      # context ||= context || window; ?????

      if target?
        @context = context
        @element = target
        type     = target.toString().match(/TiUI([A-Z][a-zA-Z]+)/)
        @type    = type[1] if !! type
        return this

    return `undefined`

  @fn = @prototype = @init.prototype =
     # Internal - used to trigger or bind event if callback exists
    _bind_or_trigger: (event, callback) ->
      if callback
        @bind event, callback
      else
        @trigger event

    # Bind callback to execute when event is fired
    bind: (event, callback) ->
      @element.addEventListener event, (e) -> callback(e)
      this

    # Remove callback previously bound to event
    unbind: (event, callback) ->
      @element.removeEventListener event, (e) -> callback(e)
      this

    # Fire event
    trigger:  (event, callback) ->
      @element.fireEvent event
      this

    # Create or execute click event
    #
    # Create click event:
    #
    #     click(function() {
    #       alert('I was clicked!');
    #     });
    #
    # Execute click event:
    #
    #     click();
    click: (callback) ->
      @_bind_or_trigger 'click', callback
      this

    # Create or execute focus event (see click above for details)
    focus: (callback) ->
      if callback
        @bind 'focus', callback
      else
        @element.focus() # fireEvent('focus') doesn't work here
      this

    # Create or execute blur event (see click above for details)
    blur: (callback) ->
      if callback
        @bind 'blur', callback
      else
        @element.blur() # fireEvent('blur') doesn't work here
      this

    # Add child to element
    add: (child) ->
      @element.add child
      this

    # Remove child from element
    remove: (view) ->
      @element.remove view
      this

    # Hide element
    hide: ->
      @element.hide()
      this

    # Show element
    show: ->
      @element.show()
      this

    # Animate element, execute callback upon completion
    animate: (animation, callback) ->
      @element.animate animation, callback
      this

    # Get or set element attribute
    #
    # Get:
    #     attr('name');
    #
    # Set:
    #     attr('name', 'Joshua Priddle');
    attr: (attr, value) ->
      @element[attr] = value if value
      @element[attr]

    # Get or set element text
    text: (text) ->
      @attr 'text', text

  # TiFighter Utility Functions

  # Shorthand for Ti.API logger methods
  #
  # JSON.stringifys message if it is not a string
  @console = @log = (message, level) ->
    message = JSON.stringify message if typeof message != "string"
    Ti.API[level || 'info'](message)

  # Fire an alert, should be used for debugging only
  #
  # JSON.stringifys message if it is not a string
  @alert = (message) ->
    message = JSON.stringify message if typeof message != "string"
    alert message

  # Iterates over an object invoking callback for each member
  #
  # callback: function(value, key) {}
  @each = (object, callback, context) ->
    for key of object
      callback.call(context, object[key], key, object) if object[key]
    return

  # Iterates over an object returning callback for each member
  #
  # callback:
  #     function(value, key) {
  #       return "Value is " + value;
  #     }
  @map = (object, callback, context) ->
    out = []
    for key of object
      if object[key]
        out.push callback.call(context, object[key], key, object)
    return out

  # Extends destination with source's attributes
  @extend = (destination, source, deepcopy) ->
    for prop of source
      if deepcopy && source[prop] && source[prop].constructor == Object
        destination[prop] = TiFighter.extend destination[prop], source[prop]
      else if source[prop]
        destination[prop] = source[prop]
    destination

  # Simple key/value store using Ti.App.Properties
  #
  # Set config:
  #     TiFighter.config('user', {username: 'itspriddle'})
  #
  # Get config:
  #     TiFighter.config('user')
  #
  # Delete config:
  #     TiFighter.config('user', null);
  @config = (key, value) ->
    if arguments.length == 2
      if value == null && Ti.App.Properties.hasProperty key
        Ti.App.Properties.removeProperty key
      else
        Ti.App.Properties.setString key, JSON.stringify(value)
    else if arguments.length == 1
      data = Ti.App.Properties.getString key, false
      data? && JSON.parse(data) || `undefined`

  # Detect simulators
  #
  # If callback is supplied and we're using the simulator, execute/return it
  # Otherwise return true or false if were using the simulator
  @development = (callback) ->
    sim = Ti.Platform.model.match(/sdk|Simulator/)
    if sim && callback
      callback()
    else
      sim

  # Detect production (basically the opposite of $.development)
  @production = (callback) ->
    production = ! TiFighter.development()
    if production && callback
      callback()
    else
      production

  # Detect iphone
  #
  # If callback is supplied and this is iphone, execute and return it
  # Otherwise return true if iphone or false
  @iphone = (callback) ->
    iphone = Ti.Platform.osname == 'iphone'
    if iphone && callback
      callback()
    else
      iphone

  # Detect ipad
  #
  # If callback is supplied and this is ipad, execute and return it
  # Otherwise return true if ipad or false
  @ipad = (callback) ->
    ipad = Ti.Platform.osname == 'ipad'
    if ipad && callback
      callback()
    else
      ipad

  # Detect android
  #
  # If callback is supplied and this is android, execute and return it
  # Otherwise return true if android or false
  @android = (callback) ->
    android = Ti.Platform.osname == 'android'
    if android && callback
      callback()
    else
      android

  # strftime, based on <http://github.com/github/jquery-relatize_date>
  @strftime = (date, format) ->
    shortDays   = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]
    days        = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ]
    shortMonths = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]
    months      = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ]
    day         = date.getDay()
    month       = date.getMonth()
    hours       = date.getHours()
    minutes     = date.getMinutes()
    pad         = (num) ->
      string = num.toString(10)
      new Array((2 - string.length) + 1).join('0') + string

    format.replace /\%([aAbBcdHImMpSwyY])/g, (part) ->
      out = null
      switch part[1]
        when 'a' then out = shortDays[day]
        when 'A' then out = days[day]
        when 'b' then out = shortMonths[month]
        when 'B' then out = months[month]
        when 'c' then out = date.toString()
        when 'd' then out = pad(date.getDate())
        when 'H' then out = pad(hours)
        when 'I' then out = pad((hours + 12) % 12)
        when 'm' then out = pad(month + 1)
        when 'M' then out = pad(minutes)
        when 'p' then out = hours > 12 ? 'PM' : 'AM'
        when 'S' then out = pad(date.getSeconds())
        when 'w' then out = day
        when 'y' then out = pad(date.getFullYear() % 100)
        when 'Y' then out = date.getFullYear().toString()
      out

  # Converts a date into a "relative" notation. Eg: 1 hour ago, 2 days ago, about
  # 5 minutes ago.  Based on GitHub's jQuery Relatize Date
  # Base on <https://github.com/github/jquery-relatize_date>
  @relatizeDate = (date, includeTime) ->
    distanceOfTimeInWords = (fromTime, toTime, includeTime) ->
      delta = parseInt((toTime.getTime() - fromTime.getTime()) / 1000, 10)
      if delta < 60
        'less than a minute ago'
      else if delta < 120
        'about a minute ago';
      else if delta < (45 * 60)
        (parseInt(delta / 60, 10)).toString() + ' minutes ago'
      else if delta < (120 * 60)
        'about an hour ago';
      else if delta < (24 * 60 * 60)
        'about ' + (parseInt(delta / 3600, 10)).toString() + ' hours ago'
      else if delta < (48 * 60 * 60)
        '1 day ago'
      else
        days = (parseInt(delta / 86400, 10)).toString()
        if days > 5
          fmt = '%B %d, %Y'
          fmt += ' %I:%M %p' if includeTime
          TiFighter.strftime fromTime, fmt
        else
          days + " days ago"

    distanceOfTimeInWords(new Date(date), new Date(), includeTime)

  # Trim leading/trailing whitespace
  @trim = (string) -> String(string).replace /^\s+|\s+$/g, ''

  # Returns false if object is false/undefined or a blank string
  @isset = (object) -> object? && TiFighter.trim(object) != ''

  # Get data via AJAX
  #
  # Usage:
  #
  #     TiFighter.ajax({
  #       url: '/pong',
  #       type: 'PUT',
  #       onload: function() {
  #         alert('It worked!');
  #       },
  #       onerror: function() {
  #         alert('Awww, it broke :(');
  #       },
  #       headers: {
  #         'X-My-Custom-Header': 'I like turtles!',
  #         'X-ZIBIT': 'Yo Dawg, I heard you like custom request headers...'
  #       }
  #     });
  #
  #     // Use async: false to return output
  #     var output = TiFighter.ajax({
  #       url: '/pong',
  #       type: 'GET',
  #       async: false
  #     });
  @ajax = (settings) ->
    settings = settings || {}
    unless settings.url?
      TiFighter.console "ERROR: Must set settings.url!", 'error'
      return

    # Defaults
    settings.type    = settings.type    || 'GET'
    settings.async   = settings.async   || true
    settings.headers = settings.headers || {}
    settings.data    = settings.data    || {}
    settings.timeout = settings.timeout || 60000

    xhr = Ti.Network.createHTTPClient()

    if TiFighter.android() && settings.async == false
      TiFighter.console("WARNING: Android doesn't support async = false", 'error')

    xhr.setTimeout settings.timeout
    xhr.open settings.type, settings.url, !settings.async

    if settings.type == 'PUT' || settings.type == 'DELETE'
      xhr.setRequestHeader 'X-HTTP-Method-Override', settings.type

    TiFighter.each ['onload', 'onerror', 'onreadystatechange', 'onsendstream'], (callback) ->
      if settings[callback] && typeof settings[callback] == 'function'
        xhr[callback] = settings[callback]
        return

    if settings.username?
      settings.headers.Authorization = 'Basic ' +
        String(Ti.Utils.base64encode settings.username + ':' + settings.password)

    if settings.headers?
      TiFighter.each settings.headers, (val, key) ->
        xhr.setRequestHeader key, val
        return

    xhr.send settings.data
    xhr

  # (Private) Get JSON via AJAX, returns a JavaScript object
  getJSON = (settings) ->
    settings = settings || {}
    settings.async = false;
    ajax = TiFighter.ajax settings
    JSON.parse ajax.responseText

  # Get JSON from url
  @get = (url) -> getJSON url: url

  # POST data to url
  @post = (url, data) -> getJSON url: url, data: data, method: 'POST'

  # PUT data to url
  @put = (url, data) -> getJSON url: url, data: data, method: 'PUT'

  # Send DELETE to url
  @del = (url) -> getJSON url: url, method: 'DELETE'

  # Prompt user to rate this app (iPhone only).
  # Greg Pierce, <https://gist.github.com/470113>
  @rater = (settings) ->
    return if TiFighter.android()

    settings = settings || {}

    # Name of your App in the App Store
    settings.appName = settings.appName || 'Rename Me!'

    # URL for your App in iTunes
    settings.appURL = settings.appURL || 'Rename me!'

    # Interval to prompt for feedback
    settings.interval = settings.interval || 20

    # Title of the alert box
    settings.title = settings.title || 'Feedback'

    # Message displayed in the alert box
    # The string '{app_name}' will be replaced by settings.appName
    settings.message = settings.message || 'Thanks for using {app_name}, please rate us in the App Store!'

    # Store the launch count and if user declined feedback prompt
    data =
      launchCount: 0
      neverRemind: false

    # Saved data
    stored = TiFighter.config('RaterData')

    data = stored if stored

    data.launchCount++

    TiFighter.config 'RaterData', data

    return if data.neverRemind || data.launchCount % settings.interval != 0

    alert = Ti.UI.createAlertDialog
      title:       "Feedback"
      message:     settings.message.replace '{app_name}', settings.appName
      buttonNames: [ "Rate Now", "Don't Remind Me", "Not Now" ]
      cancel:      2

    alert.addEventListener 'click', (e) ->
      if e.index == 0 || e.index == 1
        data.neverRemind = true
        TiFighter.config('RaterData', data)
      Ti.Platform.openURL(appURL) if e.index == 0

    alert.show()

  # Include file relative from Resources directory
  # Taken from <https://github.com/dawsontoth/Appcelerator-Titanium-Redux/blob/5e3cb2a64fc45dcd67fe21562852c44d6737c27c/redux.js#L158-191>
  @include = ->
    # android doesn't require path juggling
    if TiFighter.android()
      Ti.include.apply(null, arguments)
    else
      # grab the path from the current window's url!
      # split the url into an array around each /
      context = (Ti.UI.currentWindow && Ti.UI.currentWindow.url.split('/')) || ['']
      # pop the file name out of the array; we don't need it
      context.pop()
      # change each folder name into a .. (to get back to the root)
      context[arg] = '..' for arg in context

      # join it all together with / again
      relative = context.join('/')

      # put a / on the end, if we need it
      relative += '/' if relative
      # now iterate over our arguments using this relative path!
      Ti.include(relative + arg) for arg in arguments
