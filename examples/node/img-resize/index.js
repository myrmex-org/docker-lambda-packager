const got = require('got');
const sharp = require('sharp');


async function handler(event) {
  let address = 'https://raw.githubusercontent.com/myrmex-org/myrmex/master/images/myrmex.png';
  let size = 200;
  if (event.queryStringParameters && event.queryStringParameters.address) {
    address = event.queryStringParameters.address;
  }
  if (event.queryStringParameters && event.queryStringParameters.size) {
    size = parseInt(event.queryStringParameters.size, 10);
  } 

  const sourceStream = got.stream(address);
  const resizerStream = sharp().resize(size).png();
  sourceStream.pipe(resizerStream);
 
  return new Promise((resolve, reject) => {
    const chunks = [];
    resizerStream.on('data', (chunk) => {
      chunks.push(chunk);
    });
    resizerStream.on('end', () => {
      resolve({
        statusCode: 200,
        headers: { 'Content-Type': 'image/png' },
        body: Buffer.concat(chunks).toString('base64'),
        isBase64Encoded: true
      });
    });
    resizerStream.on('error', reject);
  });
}

module.exports.handler = handler;
