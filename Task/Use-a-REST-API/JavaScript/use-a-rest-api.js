var fs = require('fs');
var request = require('request');

var meetup = function() {
  var key = fs.readFileSync('api_key.txt', 'utf-8');
  var url = "https://api.meetup.com";

  var composeURL = function(root, object) {
    return root + '?' + JSON.stringify(object).replace(/":"/g, '=').replace(/","/g, '&').slice(2, -2)
  }

  var get = function(params, callback, path) {
    params.key = key;

    request.get(composeURL(url + (path || '/2/open_events'), params), function(err, res, body) {
      if ( err ) {
        console.error(err);
        return false;
      }


      callback(JSON.parse(body)['results']);
    })
  }


  var post = function(details, callback, path) {
    details.key = key;

    request.post({
      headers: { 'content-type' : 'application/x-www-form-urlencoded' },
      url: url + (path || '/2/event'),
      form: details
    }, function(err, res, body) {
      callback(body);
    })
  }

  var parseEvent = function(mEvent) {
    /*
     * A simple function that converts JSON to
     * string in a pretty way
    **/
    var name = mEvent['name'] || '';
    var desc = mEvent['desc'] || '';
    var url = mEvent['url'] || '';

    if ( mEvent['venue'] ) {
      var city = mEvent['venue']['city'] || '';
      var lat = mEvent['venue']['lat'] || '';
      var lon = mEvent['venue']['lon'] || '';
    }

    if ( mEvent['group'] )
      var group = mEvent['group']['name'] || '';

    var parsed = '';

    if ( name ) parsed += 'Name: ' + name + '\n';
    if ( desc ) parsed += 'Description: ' + desc + '\n';
    if ( url ) parsed += 'Url: ' + url + '\n';
    if ( city ) parsed += 'City: ' + city + '\n';
    if ( lat ) parsed += 'Latitude: ' + lat + '\n';
    if ( lon ) parsed += 'Longitude: ' + lon + '\n';
    if ( group ) parsed += 'Group: ' + group + '\n';

    return parsed;

  };

  var parseEvents = function(results) {
    console.log('a');
    for ( var i = 0; i < results.length; i++ ) {
      console.log( parseEvent(results[i]) );
    }
  }

  return {
    get: get,
    parseEvents: parseEvents,
    post: post
  }
}



meetup().get({
  // More Info: http://www.meetup.com/meetup_api/docs/2/open_events/
  topic: 'photo',
  city: 'nyc'
}, function(results) {
  meetup().parseEvents(results);
});


/*
 * Getting group ID and group urlname
 *
 * The URL name is simply the part after meetup.com/ on a meetup group.
 * Example, ID of meetup.com/foodie-programmers is 'foodie-programmers'.
 *
 * Running the code below with the group name will give the group ID, an integer.

meetup().get({
  'group_urlname': 'foodie-programmers'
}, function(group) {
  console.log(group.id);
}, '/2/groups');

 * Using the above group_id and the group_urlname manually,
 * you can post events to a group with the below code
**/

meetup().post({
  // More Info: http://www.meetup.com/meetup_api/docs/:urlname/venues/#create
  name: 'Finding Nemo',
  address_1: 'p sherman 42 wallaby way sydney',
  city: 'sydney',
  country: 'australia',
  // state: needed if in US or CA.
}, function(venue) {
  console.log('Venue: ', venue, venue.id);
  // Prints a venue ID that can be used to create a event
}, '/' + '{{ foodie-programmers }}' + '/venues');
// This needs a valid urlname for the group


meetup().post({
  // More Info: http://www.meetup.com/meetup_api/docs/2/groups/
  group_id: 42, // Group ID goes here
  group_urlname: 'foodie-programmers',
  name: 'Tomato Python Fest',
  description: 'Code vegetables in Python! Special speech by Guido Van Ossum',
  duration: 1000 * 60 * 60 * 2, // Duration in milliseconds
  time: 1419879086343, // Milliseconds since epoch
  why: 'We should do this because... Less than 250 characters',
  hosts: 'up to 5 comma separated member ids',
  venue_id: 42, // Integer, ID of venue. Venue can be created with the above.
  lat: 42, // Latitude, Integer
  lon: 42, // Longitude, Integer
  simple_html_description: 'Event description in <b>simple html</b>. Less than <i>50000</i> characters.'
}, function(result) {
  console.log('Event: ', result);
})
