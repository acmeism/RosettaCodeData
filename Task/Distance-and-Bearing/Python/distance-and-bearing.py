''' Rosetta Code task Distance_and_Bearing '''

from math import radians, degrees, sin, cos, asin, atan2, sqrt
from pandas import read_csv


EARTH_RADIUS_KM = 6372.8
TASK_CONVERT_NM =  0.0094174
AIRPORT_DATA_FILE = 'airports.dat.txt'

QUERY_LATITUDE, QUERY_LONGITUDE = 51.514669, 2.198581


def haversine(lat1, lon1, lat2, lon2):
    '''
    Given two latitude, longitude pairs in degrees for two points on the Earth,
    get distance (nautical miles) and initial direction of travel (degrees)
    for travel from lat1, lon1 to lat2, lon2
    '''
    rlat1, rlon1, rlat2, rlon2 = [radians(x) for x in [lat1, lon1, lat2, lon2]]
    dlat = rlat2 - rlat1
    dlon = rlon2 - rlon1
    arc = sin(dlat / 2) ** 2 + cos(rlat1) * cos(rlat2) * sin(dlon / 2) ** 2
    clen = 2.0 * degrees(asin(sqrt(arc)))
    theta = atan2(sin(dlon) * cos(rlat2),
                  cos(rlat1) * sin(rlat2) - sin(rlat1) * cos(rlat2) * cos(dlon))
    theta = (degrees(theta) + 360) % 360
    return EARTH_RADIUS_KM * clen * TASK_CONVERT_NM, theta


def find_nearest_airports(latitude, longitude, wanted=20, csv=AIRPORT_DATA_FILE):
    ''' Given latitude and longitude, find `wanted` closest airports in database file csv. '''
    airports = read_csv(csv, header=None, usecols=[1, 3, 5, 6, 7], names=[
                        'Name', 'Country', 'ICAO', 'Latitude', 'Longitude'])
    airports['Distance'] = 0.0
    airports['Bearing'] = 0
    for (idx, row) in enumerate(airports.itertuples()):
        distance, bearing = haversine(
            latitude, longitude, row.Latitude, row.Longitude)
        airports.at[idx, 'Distance'] = round(distance, ndigits=1)
        airports.at[idx, 'Bearing'] = int(round(bearing))

    airports.sort_values(by=['Distance'], ignore_index=True, inplace=True)
    return airports.loc[0:wanted-1, ['Name', 'Country', 'ICAO', 'Distance', 'Bearing']]


print(find_nearest_airports(QUERY_LATITUDE, QUERY_LONGITUDE))
