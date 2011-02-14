
var fs = require('fs');

console.log(process.cwd());
// Read nodebox configuration, then start the app
fs.readFile('/var/www/nodebox-example/nodebox.json', function (err, data) {
  if (err) throw err;
  var config = JSON.parse(data);
  var env = config.environment;
  var port = config.app_port || env == "production" ? 8080 : 80;
  listen(env, port);
});

function listen(environment, port) {
  var http = require('http');
  http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello World, I Am A NodeBox\n');
  }).listen(port);
  console.log("Server listening on port:" + port);
}

