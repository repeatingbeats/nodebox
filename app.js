
var fs = require('fs'),
    http = require('http')
;

var config = JSON.parse(fs.readFileSync(__dirname + '/nodebox.json'));
var env = config.environment;
var port = config.app_port || env == "production" ? 8080: 80;

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World, I Am A NodeBox\n');
}).listen(port);
console.log("Server listening on port: " + port);

