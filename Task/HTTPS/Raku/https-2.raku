use HTTP::UserAgent;
say HTTP::UserAgent.new.get('https://sourceforge.net/').content;
