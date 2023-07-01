import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const addon = require('../build/Release/md5sum-native');

export default addon.md5sum;
