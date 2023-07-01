use LMDB;

my %DB := LMDB::DB.open(:path<some-dir>, %connection-parameters);
