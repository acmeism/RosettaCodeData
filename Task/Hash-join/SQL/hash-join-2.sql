select /*+ use_hash */ * from people join nemesises using(name);
