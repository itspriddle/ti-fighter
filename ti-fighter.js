/**
 * TiFighter: Wage intergalactic war on your Titanium Mobile Apps
 *
 * TiFighter is a jQuery-like library for use with
 * Titanium Mobile applications.
 *
 * @author      Joshua Priddle <jpriddle@nevercraft.net>
 * @url         https://github.com/itspriddle/ti-fighter
 * @version     0.0.0
 */

var TiFighter = (function(window) {

  /**
   * Initialize a new TiFighter object
   */

  var TiFighter = function(el, context) {
    return new TiFighter.init(el, context);
  };

  // --------------------------------------------------------------------

  /**
   * Initialize a new TiFighter object
   * Tries to find el within context
   */

  TiFighter.init = function(el, context) {
    if ( ! el) {
      return this;
    } else {
      var target;
      if (typeof el == 'string') {
        target    = context[el];
        this.name = target;
      } else {
        target = el;
      }

      context = context || window;

      if (target !== undefined) {
        this.context = context;
        this.element = target;
        var type     = target.toString().match(/TiUI([A-Z][a-zA-Z]+)/);
        if ( !! type) {
          this.type = type[1];
        }
        return this;
      }
    }
    return undefined;
  };

  // --------------------------------------------------------------------

  /**
   * Functions exposed to every TiFighter object
   */

  TiFighter.fn = TiFighter.prototype = TiFighter.init.prototype = {
     // Internal - used to trigger or bind event if callback exists
    _bind_or_trigger: function(event, callback) {
      if (callback) {
        this.bind(event, callback);
      } else {
        this.trigger(event);
      }
    },

    /**
     * Bind callback to execute when event is fired
     */

    bind: function(event, callback) {
      this.element.addEventListener(event, function(e) {
        callback(e);
      });
      return this;
    },

    /**
     * Remove callback previously bound to event
     */

    unbind: function(event, callback) {
      this.element.removeEventListener(event, callback);
      return this;
    },

    /**
     * Fire event
     */

    trigger: function(event) {
      this.element.fireEvent(event);
      return this;
    },

    /**
     * Create or execute click event
     *
     * Create click event:
     *
     *   click(function() {
     *     alert('I was clicked!');
     *   });
     *
     * Execute click event:
     *   click();
     */

    click: function(callback) {
      this._bind_or_trigger('click', callback);
      return this;
    },

    /**
     * Create or execute bind event (see click above for details)
     */

    focus: function(callback) {
      this._bind_or_trigger('focus', callback);
      return this;
    },

    /**
     * Create or execute blur event (see click above for details)
     */

    blur: function(callback) {
      this._bind_or_trigger('blur', callback);
      return this;
    },

    /**
     * Add child to element
     */

    add: function(child) {
      this.element.add(child);
      return this;
    },

    /**
     * Remove child from element
     */

    remove: function(view) {
      this.element.remove(view);
      return this;
    },

    /**
     * Hide element
     */

    hide: function() {
      this.element.hide();
      return this;
    },

    /**
     * Show element
     */

    show: function() {
      this.element.show();
      return this;
    },

    /**
     * Animate element, execute callback upon completion
     */

    animate: function(animation, callback) {
      this.element.animate(animation, callback);
      return this;
    },

    /**
     * Get or set element attribute
     *
     * Get:
     *   attr('name');
     *
     * Set:
     *   attr('name', 'Joshua Priddle');
     */
    attr: function(attr, value) {
      if (value) {
        this.element[attr] = value;
      }
      return this.element[attr];
    },

    /**
     * Get or set element text
     */

    text: function(text) {
      return this.attr('text', text);
    }
  };

  // TiFighter Utility Functions ----------------------------------------

  /**
   * Shorthand for Ti.API logger methods
   *
   * JSON.stringifys message if it is not a string
   */

  TiFighter.console = TiFighter.log = function(message, level) {
    if (typeof message != "string") {
      message = JSON.stringify(message);
    }
    Ti.API[level || 'info'](message);
  };

  // --------------------------------------------------------------------

  /**
   * Fire an alert, should be used for debugging only
   *
   * JSON.stringifys message if it is not a string
   */

  TiFighter.alert = function(message) {
    if (typeof message != "string") {
      message = JSON.stringify(message);
    }
    alert(message);
  };

  // --------------------------------------------------------------------

  /**
   * Iterates over an object invoking callback for each member
   *
   * callback: function(value, key) {}
   */

  TiFighter.each = function(object, callback, context) {
    for (var key in object) {
      if (object[key]) {
        callback.call(context, object[key], key, object);
      }
    }
  };

  // --------------------------------------------------------------------

  /**
   * Iterates over an object returning callback for each member
   *
   * callback: function(value, key) { return "Value is " + value; }
   */

  TiFighter.map = function(object, callback, context) {
    var out = [];
    for (var key in object) {
      if (object[key]) {
        out.push(callback.call(context, object[key], key, object));
      }
    }
    return out;
  };

  // --------------------------------------------------------------------

  /**
   * Extends destination with source's attributes
   */

  TiFighter.extend = function(destination, source) {
    for (var prop in source) {
      if (source[prop]) {
        destination[prop] = source[prop];
      }
    }
    return destination;
  };

  // --------------------------------------------------------------------

  /**
   * Simple key/value store using Ti.App.Properties
   *
   * Set config:
   *   TiFighter.config('user', {username: 'itspriddle'})
   *
   * Get config:
   *   TiFighter.config('user')
   *
   * Delete config:
   *   TiFighter.config('user', null);
   */

  TiFighter.config = function(key, value) {
    if (arguments.length == 2) {
      if (value === null && Ti.App.Properties.hasProperty(key)) {
        Ti.App.Properties.removeProperty(key);
      } else {
        Ti.App.Properties.setString(key, JSON.stringify(value));
      }
    } else if (arguments.length == 1) {
      var data = Ti.App.Properties.getString(key, false);
      return data && JSON.parse(data) || undefined;
    }
  };

  // --------------------------------------------------------------------

  /**
   * Detect simulators
   *
   * If callback is supplied and we're using the simulator, execute/return it
   * Otherwise return true or false if were using the simulator
   */

  TiFighter.development = function(callback) {
    var sim = Ti.Platform.model == 'google_sdk' || Ti.Platform.model == 'Simulator';
    if (sim && callback) {
      return callback();
    } else {
      return sim;
    }
  };

  // --------------------------------------------------------------------

  /**
   * Detect production (basically the opposite of $.development)
   */

  TiFighter.production = function(callback) {
    var production = ! TiFighter.development();
    if (production && callback) {
      return callback();
    } else {
      return production;
    }
  };

  // --------------------------------------------------------------------

  /**
   * Detect iphone
   *
   * If callback is supplied and this is iphone, execute and return it
   * Otherwise return true if iphone or false
   */

  TiFighter.iphone = function(callback) {
    var iphone = Ti.Platform.osname == 'iphone';
    if (iphone && callback) {
      return callback();
    } else {
      return iphone;
    }
  };

  // --------------------------------------------------------------------

  /**
   * Detect ipad
   *
   * If callback is supplied and this is ipad, execute and return it
   * Otherwise return true if ipad or false
   */

  TiFighter.ipad = function(callback) {
    var ipad = Ti.Platform.osname == 'ipad';
    if (ipad && callback) {
      return callback();
    } else {
      return ipad;
    }
  };

  // --------------------------------------------------------------------

  /**
   * Detect android
   *
   * If callback is supplied and this is android, execute and return it
   * Otherwise return true if android or false
   */

  TiFighter.android = function(callback) {
    var android = Ti.Platform.osname == 'android';
    if (android && callback) {
      return callback();
    } else {
      return android;
    }
  };

  // --------------------------------------------------------------------

  /**
   * strftime, based on http://github.com/github/jquery-relatize_date
   */

  TiFighter.strftime = function(date, format) {
    var shortDays   = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ],
        days        = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ],
        shortMonths = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ],
        months      = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ],
        day         = date.getDay(), month = date.getMonth(),
        hours       = date.getHours(), minutes = date.getMinutes(),
        pad         = function(num) {
          var string = num.toString(10);
          return new Array((2 - string.length) + 1).join('0') + string;
        };

    return format.replace(/\%([aAbBcdHImMpSwyY])/g, function(part) {
      var out = null;
      switch (part[1]) {
        case 'a': out = shortDays[day]; break;
        case 'A': out = days[day]; break;
        case 'b': out = shortMonths[month]; break;
        case 'B': out = months[month]; break;
        case 'c': out = date.toString(); break;
        case 'd': out = pad(date.getDate()); break;
        case 'H': out = pad(hours); break;
        case 'I': out = pad((hours + 12) % 12); break;
        case 'm': out = pad(month + 1); break;
        case 'M': out = pad(minutes); break;
        case 'p': out = hours > 12 ? 'PM' : 'AM'; break;
        case 'S': out = pad(date.getSeconds()); break;
        case 'w': out = day; break;
        case 'y': out = pad(date.getFullYear() % 100); break;
        case 'Y': out = date.getFullYear().toString(); break;
      }
      return out;
    });
  };

  // --------------------------------------------------------------------

  TiFighter.relatizeDate = function(date, includeTime) {
    function distanceOfTimeInWords(fromTime, toTime, includeTime) {

      var delta = parseInt((toTime.getTime() - fromTime.getTime()) / 1000, 10);
      if (delta < 60) {
        return 'less than a minute ago';
      } else if (delta < 120) {
        return 'about a minute ago';
      } else if (delta < (45 * 60)) {
        return (parseInt(delta / 60, 10)).toString() + ' minutes ago';
      } else if (delta < (120 * 60)) {
        return 'about an hour ago';
      } else if (delta < (24 * 60 * 60)) {
        return 'about ' + (parseInt(delta / 3600, 10)).toString() + ' hours ago';
      } else if (delta < (48 * 60 * 60)) {
        return '1 day ago';
      } else {
        var days = (parseInt(delta / 86400, 10)).toString();
        if (days > 5) {
          var fmt  = '%B %d, %Y';
          if (includeTime) {
            fmt += ' %I:%M %p';
          }
          return TiFighter.strftime(fromTime, fmt);
        } else {
          return days + " days ago";
        }
      }
    }

    return distanceOfTimeInWords(new Date(date), new Date(), includeTime);
  };

  // --------------------------------------------------------------------

  /**
   * Trim leading/trailing whitespace
   */

  TiFighter.trim = function(string) {
    return String(string).replace(/^\s+|\s+$/g, '');
  };

  // --------------------------------------------------------------------

  /**
   * Returns false if object is false/undefined or a blank string
   */

  TiFighter.isset = function(object) {
    return object && object !== undefined && TiFighter.trim(object) !== '';
  };

  // --------------------------------------------------------------------

  /**
   * Get data via AJAX
   *
   * Usage:
   *
   *   TiFighter.ajax({
   *     url: '/pong',
   *     method: 'PUT',
   *     onload: function() {
   *       alert('It worked!');
   *     },
   *     onerror: function() {
   *       alert('Awww, it broke :(');
   *     },
   *     headers: {
   *       'X-My-Custom-Header': 'I like turtles!',
   *       'X-ZIBIT': 'Yo Dawg, I heard you like custom request headers...'
   *     }
   *   });
   *
   *   // Use async: false to return output
   *   var output = TiFighter.ajax({
   *     url: '/pong',
   *     method: 'GET',
   *     async: false
   *   });
   */

  TiFighter.ajax = function(settings) {

    if ( ! settings.url) {
      TiFighter.console("ERROR: Must set settings.url!", 'error');
      return;
    }

    var xhr   = Ti.Network.createHTTPClient(),
        async = settings.async === false ? false : true;

    xhr.setTimeout(settings.timeout || 60000);
    xhr.open(settings.method || 'GET', settings.url, async);

    if (settings.method == 'PUT' || settings.method == 'DELETE') {
      xhr.setRequestHeader('X-HTTP-Method-Override', settings.method);
    }

    TiFighter.each(['onload', 'onerror', 'onreadystatechange', 'onsendstream'], function(callback) {
      if (settings[callback] && typeof settings[callback] == 'function') {
        xhr[callback] = settings[callback];
      }
    });

    if (settings.headers && settings.headers.length > 0) {
      TiFighter.each(settings.headers, function(val, key) {
        xhr.setRequestHeader(key, val);
      });
    }

    xhr.send(settings.data || {});
    return xhr;
  };

  // --------------------------------------------------------------------

  /**
   * (Private) Get JSON via AJAX, returns a JavaScript object
   */

  function getJSON(settings) {
    settings.async = false;
    var ajax = TiFighter.ajax(settings);
    return JSON.parse(ajax.responseText);
  }

  // --------------------------------------------------------------------

  /**
   * Get JSON from url
   */

  TiFighter.get = function(url) {
    return getJSON({url: url});
  };

  // --------------------------------------------------------------------

  /**
   * POST data to url
   */

  TiFighter.post = function(url, data) {
    return getJSON({url: url, data: data, method: 'POST'});
  };

  // --------------------------------------------------------------------

  /**
   * PUT data to url
   */

  TiFighter.put = function(url, data) {
    return getJSON({url: url, data: data, method: 'PUT'});
  };

  // --------------------------------------------------------------------

  /**
   * Send DELETE to url
   */

  TiFighter.del = function(url) {
    return getJSON({url: url, method: 'DELETE'});
  };

  // --------------------------------------------------------------------

  /**
   * Prompt user to rate this app (iPhone only).
   * Greg Pierce - https://gist.github.com/470113
   */

  TiFighter.rater = function(settings) {
    if (TiFighter.android()) {
      return;
    }

    settings = settings || {};

    // Name of your App in the App Store
    var appName = settings.appName || 'Rename Me!',

    // URL for your App in iTunes
    appURL = settings.appURL || 'Rename me!',

    // Interval to prompt for feedback
    interval = settings.interval || 20,

    // Title of the alert box
    title = settings.title || 'Feedback',

    // Message displayed in the alert box
    // The string '{app_name}' will be replaced by settings.appName
    message = settings.message || 'Thanks for using {app_name}, please rate us in the App Store!',

    // Store the launch count and if user declined feedback prompt
    data = {
      launchCount: 0,
      neverRemind: false
    },

    // Saved data
    stored = TiFighter.config('RaterData');

    if (stored) {
      data = stored;
    }

    data.launchCount++;
    TiFighter.config('RaterData', data);

    if (data.neverRemind || data.launchCount % interval !== 0) { return; }

    var alert = Ti.UI.createAlertDialog({
      title:       "Feedback",
      message:     message.replace('{app_name}', appName),
      buttonNames: [ "Rate Now", "Don't Remind Me", "Not Now" ],
      cancel:      2
    });

    alert.addEventListener('click', function(e) {
      if (e.index === 0 || e.index === 1) {
        data.neverRemind = true;
        TiFighter.config('RaterData', data);
      }

      if (e.index === 0) {
        Ti.Platform.openURL(appURL);
      }
    });
    alert.show();
  };

  // --------------------------------------------------------------------

  return TiFighter;

})(this);
