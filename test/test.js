describe('downloadSolanoGem', function() {
  it('should find a valid download url', function () {
    window.loadPage();
    expect( document.getElementsByClassName('caption')[0].getAttribute('href') ).not.toMatch(/placeholder/);
    expect( document.getElementsByClassName('caption')[0].getAttribute('href') ).toMatch(/solano/);
  });
});

describe('add', function () {
  it('should add two numbers and return the result', function () {
    expect(window.add(1, 2)).toBe(3);
  });
});

describe('subtract', function () {
  it('should subtract two numbers', function () {
    expect(window.subtract(2, 1)).toBe(1);
  });
});

describe('updateAppState', function () {
  it('should push a new state into the browser history', function () {
    window.updateAppState({
      message: 'hi'
    });
    expect(window.history.state).toEqual({
      message: 'hi'
    })
  });
});
