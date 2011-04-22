(function() {
  var TiFighter, window;
  window = this;
  TiFighter = (function() {
    var getJSON;
    function TiFighter(el, context) {
      return new TiFighter.init(el, context);
    }
    TiFighter.init = function(el, context) {
      var target, type;
      if (!el) {
        return this;
      } else {
        if (typeof el === 'string') {
          target = context[el];
          this.name = target;
        } else {
          target = el;
        }
        if (target != null) {
          this.context = context;
          this.element = target;
          type = target.toString().match(/TiUI([A-Z][a-zA-Z]+)/);
          if (!!type) {
            this.type = type[1];
          }
          return this;
        }
      }
      return undefined;
    };
    TiFighter.fn = TiFighter.prototype = TiFighter.init.prototype = {
      _bind_or_trigger: function(event, callback) {
        if (callback) {
          return this.bind(event, callback);
        } else {
          return this.trigger(event);
        }
      },
      bind: function(event, callback) {
        this.element.addEventListener(event, function(e) {
          return callback(e);
        });
        return this;
      },
      unbind: function(event, callback) {
        this.element.removeEventListener(event, function(e) {
          return callback(e);
        });
        return this;
      },
      trigger: function(event, callback) {
        this.element.fireEvent(event);
        return this;
      },
      click: function(callback) {
        this._bind_or_trigger('click', callback);
        return this;
      },
      focus: function(callback) {
        if (callback) {
          this.bind('focus', callback);
        } else {
          this.element.focus();
        }
        return this;
      },
      blur: function(callback) {
        if (callback) {
          this.bind('blur', callback);
        } else {
          this.element.blur();
        }
        return this;
      },
      add: function(child) {
        this.element.add(child);
        return this;
      },
      remove: function(view) {
        this.element.remove(view);
        return this;
      },
      hide: function() {
        this.element.hide();
        return this;
      },
      show: function() {
        this.element.show();
        return this;
      },
      animate: function(animation, callback) {
        this.element.animate(animation, callback);
        return this;
      },
      attr: function(attr, value) {
        if (value) {
          this.element[attr] = value;
        }
        return this.element[attr];
      },
      text: function(text) {
        return this.attr('text', text);
      }
    };
    TiFighter.console = TiFighter.log = function(message, level) {
      if (typeof message !== "string") {
        message = JSON.stringify(message);
      }
      return Ti.API[level || 'info'](message);
    };
    TiFighter.alert = function(message) {
      if (typeof message !== "string") {
        message = JSON.stringify(message);
      }
      return alert(message);
    };
    TiFighter.each = function(object, callback, context) {
      var key;
      for (key in object) {
        if (object[key]) {
          callback.call(context, object[key], key, object);
        }
      }
      return;
    };
    TiFighter.map = function(object, callback, context) {
      var key, out;
      out = [];
      for (key in object) {
        if (object[key]) {
          out.push(callback.call(context, object[key], key, object));
        }
      }
      return out;
    };
    TiFighter.extend = function(destination, source, deepcopy) {
      var prop;
      for (prop in source) {
        if (deepcopy && source[prop] && source[prop].constructor === Object) {
          destination[prop] = TiFighter.extend(destination[prop], source[prop]);
        } else if (source[prop]) {
          destination[prop] = source[prop];
        }
      }
      return destination;
    };
    TiFighter.config = function(key, value) {
      var data;
      if (arguments.length === 2) {
        if (value === null && Ti.App.Properties.hasProperty(key)) {
          return Ti.App.Properties.removeProperty(key);
        } else {
          return Ti.App.Properties.setString(key, JSON.stringify(value));
        }
      } else if (arguments.length === 1) {
        data = Ti.App.Properties.getString(key, false);
        return (data != null) && JSON.parse(data) || undefined;
      }
    };
    TiFighter.development = function(callback) {
      var sim;
      sim = Ti.Platform.model.match(/sdk|Simulator/);
      if (sim && callback) {
        return callback();
      } else {
        return sim;
      }
    };
    TiFighter.production = function(callback) {
      var production;
      production = !TiFighter.development();
      if (production && callback) {
        return callback();
      } else {
        return production;
      }
    };
    TiFighter.iphone = function(callback) {
      var iphone;
      iphone = Ti.Platform.osname === 'iphone';
      if (iphone && callback) {
        return callback();
      } else {
        return iphone;
      }
    };
    TiFighter.ipad = function(callback) {
      var ipad;
      ipad = Ti.Platform.osname === 'ipad';
      if (ipad && callback) {
        return callback();
      } else {
        return ipad;
      }
    };
    TiFighter.android = function(callback) {
      var android;
      android = Ti.Platform.osname === 'android';
      if (android && callback) {
        return callback();
      } else {
        return android;
      }
    };
    TiFighter.strftime = function(date, format) {
      var day, days, hours, minutes, month, months, pad, shortDays, shortMonths;
      shortDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      shortMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      day = date.getDay();
      month = date.getMonth();
      hours = date.getHours();
      minutes = date.getMinutes();
      pad = function(num) {
        var string;
        string = num.toString(10);
        return new Array((2 - string.length) + 1).join('0') + string;
      };
      return format.replace(/\%([aAbBcdHImMpSwyY])/g, function(part) {
        var out;
        out = null;
        switch (part[1]) {
          case 'a':
            out = shortDays[day];
            break;
          case 'A':
            out = days[day];
            break;
          case 'b':
            out = shortMonths[month];
            break;
          case 'B':
            out = months[month];
            break;
          case 'c':
            out = date.toString();
            break;
          case 'd':
            out = pad(date.getDate());
            break;
          case 'H':
            out = pad(hours);
            break;
          case 'I':
            out = pad((hours + 12) % 12);
            break;
          case 'm':
            out = pad(month + 1);
            break;
          case 'M':
            out = pad(minutes);
            break;
          case 'p':
            out = hours > 12 && 'PM' || 'AM';
            break;
          case 'S':
            out = pad(date.getSeconds());
            break;
          case 'w':
            out = day;
            break;
          case 'y':
            out = pad(date.getFullYear() % 100);
            break;
          case 'Y':
            out = date.getFullYear().toString();
        }
        return out;
      });
    };
    TiFighter.relatizeDate = function(date, includeTime) {
      var distanceOfTimeInWords;
      distanceOfTimeInWords = function(fromTime, toTime, includeTime) {
        var days, delta, fmt;
        delta = parseInt((toTime.getTime() - fromTime.getTime()) / 1000, 10);
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
          days = (parseInt(delta / 86400, 10)).toString();
          if (days > 5) {
            fmt = '%B %d, %Y';
            if (includeTime) {
              fmt += ' %I:%M %p';
            }
            return TiFighter.strftime(fromTime, fmt);
          } else {
            return days + " days ago";
          }
        }
      };
      return distanceOfTimeInWords(new Date(date), new Date(), includeTime);
    };
    TiFighter.trim = function(string) {
      return String(string).replace(/^\s+|\s+$/g, '');
    };
    TiFighter.isset = function(object) {
      return (object != null) && TiFighter.trim(object) !== '';
    };
    TiFighter.ajax = function(settings) {
      var xhr;
      settings = settings || {};
      if (settings.url == null) {
        TiFighter.console("ERROR: Must set settings.url!", 'error');
        return;
      }
      settings.type = settings.type || 'GET';
      settings.async = settings.async || true;
      settings.headers = settings.headers || {};
      settings.data = settings.data || {};
      settings.timeout = settings.timeout || 60000;
      xhr = Ti.Network.createHTTPClient();
      if (TiFighter.android() && settings.async === false) {
        TiFighter.console("WARNING: Android doesn't support async = false", 'error');
      }
      xhr.setTimeout(settings.timeout);
      xhr.open(settings.type, settings.url, !settings.async);
      if (settings.type === 'PUT' || settings.type === 'DELETE') {
        xhr.setRequestHeader('X-HTTP-Method-Override', settings.type);
      }
      TiFighter.each(['onload', 'onerror', 'onreadystatechange', 'onsendstream'], function(callback) {
        if (settings[callback] && typeof settings[callback] === 'function') {
          xhr[callback] = settings[callback];
          return;
        }
      });
      if (settings.username != null) {
        settings.headers.Authorization = 'Basic ' + String(Ti.Utils.base64encode(settings.username + ':' + settings.password));
      }
      if (settings.headers != null) {
        TiFighter.each(settings.headers, function(val, key) {
          xhr.setRequestHeader(key, val);
          return;
        });
      }
      xhr.send(settings.data);
      return xhr;
    };
    getJSON = function(settings) {
      var ajax;
      settings = settings || {};
      settings.async = false;
      ajax = TiFighter.ajax(settings);
      return JSON.parse(ajax.responseText);
    };
    TiFighter.get = function(url) {
      return getJSON({
        url: url
      });
    };
    TiFighter.post = function(url, data) {
      return getJSON({
        url: url,
        data: data,
        method: 'POST'
      });
    };
    TiFighter.put = function(url, data) {
      return getJSON({
        url: url,
        data: data,
        method: 'PUT'
      });
    };
    TiFighter.del = function(url) {
      return getJSON({
        url: url,
        method: 'DELETE'
      });
    };
    TiFighter.rater = function(settings) {
      var alert, data, stored;
      if (TiFighter.android()) {
        return;
      }
      settings = settings || {};
      settings.appName = settings.appName || 'Rename Me!';
      settings.appURL = settings.appURL || 'Rename me!';
      settings.interval = settings.interval || 20;
      settings.title = settings.title || 'Feedback';
      settings.message = settings.message || 'Thanks for using {app_name}, please rate us in the App Store!';
      data = {
        launchCount: 0,
        neverRemind: false
      };
      stored = TiFighter.config('RaterData');
      if (stored) {
        data = stored;
      }
      data.launchCount++;
      TiFighter.config('RaterData', data);
      if (data.neverRemind || data.launchCount % settings.interval !== 0) {
        return;
      }
      alert = Ti.UI.createAlertDialog({
        title: "Feedback",
        message: settings.message.replace('{app_name}', settings.appName),
        buttonNames: ["Rate Now", "Don't Remind Me", "Not Now"],
        cancel: 2
      });
      alert.addEventListener('click', function(e) {
        if (e.index === 0 || e.index === 1) {
          data.neverRemind = true;
          TiFighter.config('RaterData', data);
        }
        if (e.index === 0) {
          return Ti.Platform.openURL(appURL);
        }
      });
      return alert.show();
    };
    TiFighter.include = function() {
      var arg, context, relative, _i, _j, _len, _len2, _results;
      if (TiFighter.android()) {
        return Ti.include.apply(null, arguments);
      } else {
        context = (Ti.UI.currentWindow && Ti.UI.currentWindow.url.split('/')) || [''];
        context.pop();
        for (_i = 0, _len = context.length; _i < _len; _i++) {
          arg = context[_i];
          context[arg] = '..';
        }
        relative = context.join('/');
        if (relative) {
          relative += '/';
        }
        _results = [];
        for (_j = 0, _len2 = arguments.length; _j < _len2; _j++) {
          arg = arguments[_j];
          _results.push(Ti.include(relative + arg));
        }
        return _results;
      }
    };
    return TiFighter;
  })();
}).call(this);
