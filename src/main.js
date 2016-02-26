(function() {
  window.add = function (num1, num2) {
    return num1 + num2;
  }
  window.subtract = function(num1, num2) {
    return num1 - num2;
  }
  window.updateAppState = function(state) {
    window.history.pushState(state || {}, document.title, 'newstate');
  }

  window.loadPage = function() {
    var xhr= new XMLHttpRequest();
    xhr.open('GET', 'http://localhost:9876/base/www/solano.html', false);
    xhr.send();
    if (xhr.readyState!==4) {
      console.log("FAILED ready state: " + xhr.readyState);
      return;
    }
    if (xhr.status!==200) { // or whatever error handling you want
      console.log("FAILED status: " + xhr.status);
      return;
    }
    document.open();
    document.write(xhr.responseText);
    document.close();
  }
})();
