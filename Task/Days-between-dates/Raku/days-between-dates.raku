say Date.new('2019-09-30') - Date.new('2019-01-01');

say Date.new('2019-03-01') - Date.new('2019-02-01');

say Date.new('2020-03-01') - Date.new('2020-02-01');

say Date.new('2029-03-29') - Date.new('2019-03-29');

say Date.new('2019-01-01') + 90;

say Date.new('2020-01-01') + 90;

say Date.new('2019-02-29') + 30;

CATCH { default { .message.say; exit; } };
