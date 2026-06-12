import eventGetter as eg
import json

def main():
    url_path = "https://api.meetup.com"         #Url to meetup API
    key_path = "api_key.txt"                    #Path to api_key.txt
    path_code = ""                              #var to store the url_path + the specific api path
    key = eg.getApiKey(key_path)

    #1-parameter get events example :
    print("1-PARAMETER EXAMPLE")
    path_code = url_path+"/2/open_events"
    eg.topic = "photo"
    response = eg.getEvent(path_code, key)
    decodeJSON(response)

    #2-parameter get events example :
    print("\n")
    print("2-PARAMETER EXAMPLE")
    path_code = url_path+"/2/open_events"
    eg.topic = "photo"
    eg.city = "nyc"
    response = eg.getEvent(path_code, key)
    decodeJSON(response)

    #Get GEO Example :
    print("\n")
    print("Get GEO Example")
    path_code = url_path+"/2/open_events"
    eg.topic = "photo"
    eg.city = None
    exclude = None
    response = eg.getEvent(path_code, key)
    decodeGEO(response)


    #Exclude topics Example
    print("\n")
    print("EXCLUDE-TOPICS EXAMPLE")
    path_code = url_path+"/2/open_events"
    eg.topic = "photo"
    eg.city = None
    exclude = "club"
    response = eg.getEvent(path_code, key)
    decodeJSONExcluding(response, exclude)



def decodeJSON(response):
    j = json.loads(response.encode('ascii','ignore').decode())   #This is a Python Dict (JSON array)
    i = 0
    results = j['results']
    while i<len(results):
        event = results[i]
        print("Event "+str(i))
        print("Event name : "+event['name'])
        print("Event URL : "+event['event_url'])
        try :
            print("City : "+str(event['venue']['city']))
        except KeyError :
            print("This event has no location assigned")

        try :
            print("Group : "+str(event['group']['name']))
        except KeyError :
            print("This event is not related to any group")

        i+=1


def decodeJSONExcluding(response, exclude):
    j = json.loads(response.encode('ascii','ignore').decode())   #This is a Python Dict (JSON array)
    i = 0
    results = j['results']
    while i<len(results):
        event = results[i]
        if 'description' in event :
            if exclude not in str(event['description']) :
                print("Event "+str(i))
                print("Event name : "+event['name'])
                print("Event URL : "+event['event_url'])
                try :
                    print("City : "+str(event['venue']['city']))
                except KeyError :
                    print("This event has no location assigned")

                try :
                    print("Group : "+str(event['group']['name']))
                except KeyError :
                    print("This event is not related to any group")

            else :
                print("Event number "+str(i)+" is excluded by its keywords")

        i+=1


def decodeGEO(response):
    j = json.loads(response.encode('ascii','ignore').decode())   #This is a Python Dict (JSON array)
    i = 0
    results = j['results']
    while i<len(results):
        event = results[i]
        print("Event "+str(i))
        print("Event name : "+event['name'])
        try :
            print("Lat : "+str(event['venue']['lat']))
            print("Lon : "+str(event['venue']['lon']))
        except KeyError :
            print("This event has no location assigned")

        i+=1



main()
