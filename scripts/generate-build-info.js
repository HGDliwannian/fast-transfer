// AIGC START
const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');

const info = {
  projectRoot: ROOT,
};

const out = path.join(ROOT, 'public', 'build-info.json');
fs.writeFileSync(out, JSON.stringify(info, null, 2));
console.log('✓ build-info.json projectRoot →', ROOT);
// AIGC END
