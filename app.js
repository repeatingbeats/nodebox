
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World, I Am A NodeBox\n');
}).listen(80);
console.log("Server running at localhost:80");
