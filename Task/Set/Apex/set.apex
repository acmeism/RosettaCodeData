public class MySetController{
    public Set<String> strSet {get; private set; }
    public Set<Id> idSet {get; private set; }

    public MySetController(){
        //Initialize to an already known collection.  Results in a set of abc,def.
        this.strSet = new Set<String>{'abc','abc','def'};

        //Initialize to empty set and add in entries.
        this.strSet = new Set<String>();
        this.strSet.add('abc');
        this.strSet.add('def');
        this.strSet.add('abc');
        //Results in {'abc','def'}

        //You can also get a set from a map in Apex. In this case, the account ids are fetched from a SOQL query.
        Map<Id,Account> accountMap = new Map<Id,Account>([Select Id,Name From Account Limit 10]);
        Set<Id> accountIds = accountMap.keySet();

        //If you have a set, you can also use it with the bind variable syntax in SOQL:
        List<Account> accounts = [Select Name From Account Where Id in :accountIds];

        //Like other collections in Apex, you can use a for loop to iterate over sets:
        for(Id accountId : accountIds){
            Account a = accountMap.get(accountId);
            //Do account stuffs here.
        }
    }
}
