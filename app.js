
var ENV_PRODUCTION = 'production',
    ENV_DEVELOPMENT = 'development'
;

var nodeboxEnv = ENV_DEVELOPMENT;
var nodeboxPort = (nodeboxEnv == ENV_PRODUCTION) ? 8080 : 80;


var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World, I Am A NodeBox\n');
}).listen(nodeboxPort);
console.log("Server running at localhost:" + nodeboxPort);

