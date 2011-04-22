# ## TiFighter
#
# TiFighter is a jQuery-like library designed to help you wage intergalactic
# war on your Titanium Mobile applications.
#

window = this

class TiFighter
  version: '0.1.0'

  # Initialize a new TiFighter object by selecting `el` from within `context`.
  # If `context` is not given, it is assumed to be the top-level `this`, which
  # would be usually be the current global namespace in your application.
  #
  # Usage:
  #     TiFighter([Titanium Object], context)
  constructor: (el, context) ->
    return new TiFighter.init el, context

  # Initialize a new TiFighter object by finding `el` within `context`.
  @init: (el, context) ->
    if ! el
      return this
    else
      if typeof el == 'string'
        target = context[el]
        @name  = target
      else
        target = el

      context = context || window

      if target?
        @context = context
        @element = target
        type     = target.toString().match /TiUI([A-Z][a-zA-Z]+)/
        @type    = type[1] if !! type
        return this

    return `undefined`

  # ### TiFighter Instance Methods
  # TiFighter.fn contains methods available to all TiFighter objects.
  @fn = @prototype = @init.prototype =
     # Internal - used to trigger or bind event. If callback exists, it is
     # bound to event. If callback is not given, the event is triggered.
    _bind_or_trigger: (event, callback) ->
      if callback
        @bind event, callback
      else
        @trigger event

    # Bind callback to execute when event is fired
    #
    # Usage:
    #     el.bind('my-event', function() {
    #       alert('HI!');
    #     });
    bind: (event, callback) ->
      @element.addEventListener event, (e) -> callback(e)
      this

    # Remove callback previously bound to event
    #
    # Usage:
    #     el.unbind('my-event');
    unbind: (event, callback) ->
      @element.removeEventListener event, (e) -> callback(e)
      this

    # Trigger event
    #
    # Usage:
    #     el.trigger('my-event');
    trigger: (event) ->
      @element.fireEvent event
      this

    # Create or execute click event
    #
    # Create click event:
    #
    #     el.click(function() {
    #       alert('I was clicked!');
    #     });
    #
    # Execute click event:
    #
    #     el.click();
    click: (callback) ->
      @_bind_or_trigger 'click', callback
      this

    # Create or execute focus event
    #
    # Create focus event:
    #
    #     el.focus(function() {
    #       alert('I was focused!');
    #     });
    #
    # Execute focus event:
    #
    #     el.focus();
    focus: (callback) ->
      if callback
        @bind 'focus', callback
      else
        @element.focus() # fireEvent('focus') doesn't work here
      this

    # Create or execute blur event
    #
    # Create blur event:
    #
    #     el.blur(function() {
    #       alert('I was blurred!');
    #     });
    #
    # Execute blur event:
    #
    #     el.blur();
    blur: (callback) ->
      if callback
        @bind 'blur', callback
      else
        @element.blur() # fireEvent('blur') doesn't work here
      this

    # Add child to element
    #
    # Usage:
    #     el.add(el2);
    add: (child) ->
      @element.add child
      this

    # Remove child from element
    #
    # Usage:
    #     el.remove(el2);
    remove: (view) ->
      @element.remove view
      this

    # Hide element
    #
    # Usage:
    #     el.hide();
    hide: ->
      @element.hide()
      this

    # Show element
    #
    # Usage:
    #     el.show();
    show: ->
      @element.show()
      this

    # Animate element, execute callback upon completion
    #
    # Usage:
    #     el.animate(animation, function() {
    #       alert("I was animated!");
    #     });
    animate: (animation, callback) ->
      @element.animate animation, callback
      this

    # Get or set element attribute
    #
    # Usage:
    #
    # Get attribute:
    #
    #     el.attr('name');
    #
    # Set attribute:
    #
    #     el.attr('name', 'Joshua Priddle');
    attr: (attr, value) ->
      @element[attr] = value if value
      @element[attr]

    # Get or set element text
    #
    # Usage:
    #     el.text('The new text');
    text: (text) ->
      @attr 'text', text

  # ### TiFighter Class Methods
  # These "class" methods are available in any script after TiFighter has been
  # included.

  # Shorthand for Ti.API logger methods. JSON.stringifys message if it is not
  # a string
  #
  # Usage:
  #     TiFighter.console("Red alert, numba one!");
  #     TiFighter.info({foo: bar});
  @console = @log = (message, level) ->
    message = JSON.stringify message if typeof message != "string"
    Ti.API[level || 'info'](message)

  # Fire an alert, should be used for debugging only. JSON.stringifys message
  # if it is not a string.
  #
  # Usage:
  #     TiFighter.alert("Red alert, numba one!");
  #     TiFighter.alert({foo: bar});
  @alert = (message) ->
    message = JSON.stringify message if typeof message != "string"
    alert message

  # Iterates over an object invoking callback for each member
  #
  # Usage:
  #     TiFighter.each(object, function(row) {
  #       alert(row);
  #     });
  #
  # Or, with the object keys available:
  #     TiFighter.each(object, function(row, key) {
  #       alert(key + row);
  #     });
  @each = (object, callback, context) ->
    for key of object
      callback.call(context, object[key], key, object) if object[key]
    return

  # Iterates over an object returning callback for each member
  #
  # Usage:
  #     var rows_out = TiFighter.map(object, function(row) {
  #       return row;
  #     });
  #
  # Or, with the object keys available:
  #     var rows_out = TiFighter.map(object, function(row, key) {
  #       return key + row;
  #     });
  @map = (object, callback, context) ->
    out = []
    for key of object
      if object[key]
        out.push callback.call(context, object[key], key, object)
    return out

  # Extends destination with source's attributes.
  #
  # Usage:
  #     TiFighter.extend(destination, source);
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
  # If callback is supplied and we're using the simulator, execute/return it.
  # Otherwise return true or false if were using the simulator
  #
  # Usage:
  #     TiFighter.development(function () {
  #       // This code only runs in development
  #     });
  @development = (callback) ->
    sim = Ti.Platform.model.match /sdk|Simulator/
    if sim && callback
      callback()
    else
      sim

  # Detect production (basically the opposite of $.development)
  #
  # Usage:
  #     TiFighter.production(function () {
  #       // This code only runs in production
  #     });
  @production = (callback) ->
    production = ! TiFighter.development()
    if production && callback
      callback()
    else
      production

  # Detect iphone
  #
  # If callback is supplied and this is iphone, execute and return it.
  # Otherwise return true if iphone or false
  #
  # Usage:
  #     TiFighter.iphone(function () {
  #       // This code only runs on iPhone
  #     });
  @iphone = (callback) ->
    iphone = Ti.Platform.osname == 'iphone'
    if iphone && callback
      callback()
    else
      iphone

  # Detect ipad
  #
  # If callback is supplied and this is ipad, execute and return it.
  # Otherwise return true if ipad or false
  #
  # Usage:
  #     TiFighter.ipad(function () {
  #       // This code only runs on iPad
  #     });
  @ipad = (callback) ->
    ipad = Ti.Platform.osname == 'ipad'
    if ipad && callback
      callback()
    else
      ipad

  # Detect Android
  #
  # If callback is supplied and this is Android, execute and return it.
  # Otherwise return true if android or false
  #
  # Usage:
  #     TiFighter.development(function () {
  #       // This code only runs on Android
  #     })l
  @android = (callback) ->
    android = Ti.Platform.osname == 'android'
    if android && callback
      callback()
    else
      android

  # Ruby style strftime
  #
  # Usage:
  #     TiFighter.strftime(date, '%Y-%m-%d');
  #
  # See also: <http://github.com/github/jquery-relatize_date>
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
        when 'p' then out = hours > 12 && 'PM' || 'AM'
        when 'S' then out = pad(date.getSeconds())
        when 'w' then out = day
        when 'y' then out = pad(date.getFullYear() % 100)
        when 'Y' then out = date.getFullYear().toString()
      out

  # Converts a date into a "relative" notation.
  # Eg: 1 hour ago, 2 days ago, about 5 minutes ago.
  #
  # Usage:
  #     TiFighter.relatizeDate(date);
  #
  # See also: <https://github.com/github/jquery-relatize_date>
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

  # Trim leading/trailing whitespace from a string
  #
  # Usage:
  #     TiFighter.trim('    I hate whitespace     ');
  @trim = (string) -> String(string).replace /^\s+|\s+$/g, ''

  # Returns false if object is false/undefined or a blank string
  @isset = (object) -> object? && TiFighter.trim(object) != ''

  # Get data via AJAX. This is based on jQuery's AJAX function as much as
  # possible. **Warning:** Syncronous XHR operations are not supported on
  # Android!
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
  #
  # Usage:
  #     TiFighter.get('http://example.com');
  @get = (url) -> getJSON url: url

  # POST data to url
  #
  # Usage:
  #     TiFighter.post('http://example.com', { username: 'username' });
  @post = (url, data) -> getJSON url: url, data: data, method: 'POST'

  # PUT data to url
  #
  # Usage:
  #     TiFighter.put('http://example.com', { username: 'username' });
  @put = (url, data) -> getJSON url: url, data: data, method: 'PUT'

  # Send DELETE to url
  #
  # Usage:
  #   TiFighter.del('http://example.com');
  @del = (url) -> getJSON url: url, method: 'DELETE'

  # Prompt user to rate this app (iPhone only).
  #
  # Usage:
  #     TiFighter.rater({
  #       appName: 'My App',
  #       appURL: 'http://myitunesurl',
  #     });
  #
  # See also: <https://gist.github.com/470113>
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

  # Include file relative from Resources directory.
  #
  # Usage:
  #     TiFighter.include('file1.js', 'file2.js');
  #
  # See also:
  # <https://github.com/dawsontoth/Appcelerator-Titanium-Redux/blob/5e3cb2a64fc45dcd67fe21562852c44d6737c27c/redux.js#L158-191>
  @include = ->
    if TiFighter.android()
      Ti.include.apply(null, arguments)
    else
      context = (Ti.UI.currentWindow && Ti.UI.currentWindow.url.split('/')) || ['']
      context.pop()
      context[arg] = '..' for arg in context
      relative = context.join('/')
      relative += '/' if relative
      Ti.include(relative + arg) for arg in arguments
