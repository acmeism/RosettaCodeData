def slurper = new groovy.json.JsonSlurper()
def result = slurper.parseText('''
{
    "people":[
        {"name":{"family":"Flintstone","given":"Frederick"},"age":35,"relationships":{"wife":"people[1]","child":"people[4]"}},
        {"name":{"family":"Flintstone","given":"Wilma"},"age":32,"relationships":{"husband":"people[0]","child":"people[4]"}},
        {"name":{"family":"Rubble","given":"Barnard"},"age":30,"relationships":{"wife":"people[3]","child":"people[5]"}},
        {"name":{"family":"Rubble","given":"Elisabeth"},"age":32,"relationships":{"husband":"people[2]","child":"people[5]"}},
        {"name":{"family":"Flintstone","given":"Pebbles"},"age":1,"relationships":{"mother":"people[1]","father":"people[0]"}},
        {"name":{"family":"Rubble","given":"Bam-Bam"},"age":1,"relationships":{"mother":"people[3]","father":"people[2]"}},
    ]
}
''')
