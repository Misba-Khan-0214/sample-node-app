const http = require('http');
http.get({host:'localhost', port:3000, path:'/'}, res => {
  console.log('STATUS', res.statusCode);
  process.exit(res.statusCode === 200 ? 0 : 2);
}).on('error', e => {
  console.error('ERROR', e.message);
  process.exit(2);
});
