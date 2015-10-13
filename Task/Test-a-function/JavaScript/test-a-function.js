const assert = require('assert');

describe('palindrome', () => {
  const pali = require('../lib/palindrome');

  describe('.check()', () => {
    it('should return true on encountering a palindrome', () => {
      assert.ok(pali.check('racecar'));
      assert.ok(pali.check('abcba'));
      assert.ok(pali.check('aa'));
      assert.ok(pali.check('a'));
    });

    it('should return true on encountering an empty string', () => {
      assert.ok(pali.check(''));
    });

    it('should return false on encountering a non-palindrome', () => {
      assert.ok(!pali.check('alice'));
      assert.ok(!pali.check('ab'));
      assert.ok(!pali.check('abcdba'));
    });
  })
});
